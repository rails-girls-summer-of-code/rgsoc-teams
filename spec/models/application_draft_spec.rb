# frozen_string_literal: true
require 'spec_helper'

RSpec.describe ApplicationDraft do
  it_behaves_like 'HasSeason'

  context 'with associations' do
    it { is_expected.to belong_to(:updater).class_name('User') }
    it { is_expected.to belong_to(:project1).class_name('Project') }
    it { is_expected.to belong_to(:project2).class_name('Project') }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }

    context 'with more than one application' do
      let(:team) { create :team }
      let!(:draft) { team.application_drafts.create }

      def build_draft
        team.application_drafts.build
      end

      context 'with an existing draft' do
        let!(:second_draft) { build_draft }

        it 'prohibits the creation of a second application draft' do
          expect { second_draft.save }.not_to change { team.application_drafts.count }
          expect(second_draft.errors[:base]).to eql ['Only one application may be lodged']
        end

        it 'allows drafts in different seasons' do
          second_draft.season = create(:season, name: 2000)
          expect { second_draft.save }.to change { team.application_drafts.count }.by(1)
        end
      end
    end

    context 'with projects' do
      it 'fails if both selected projects are the same' do
        subject.project1 = subject.project2 = build_stubbed(:project, :accepted)
        expect { subject.valid? }.to change { subject.errors[:projects] }.
          to ['must not be selected twice']
      end
    end

    context 'apply validations' do
      before do
        allow(subject).to receive(:students).and_return([])
      end

      shared_examples_for 'proxies :apply validation' do |attribute|
        it { is_expected.not_to validate_presence_of attribute }
        it { is_expected.to validate_presence_of(attribute).on(:apply) }
      end

      it_behaves_like 'proxies :apply validation', :project1
      it_behaves_like 'proxies :apply validation', :project_plan
      it_behaves_like 'proxies :apply validation', :working_together
      it_behaves_like 'proxies :apply validation', :why_selected_project

      context 'required fields for voluntary mode' do
        it { is_expected.not_to validate_presence_of :voluntary_hours_per_week }
        it { is_expected.not_to validate_presence_of(:voluntary_hours_per_week).on(:apply) }

        context 'with voluntary set to true' do
          before { subject.voluntary = true }
          it { is_expected.not_to validate_presence_of :voluntary_hours_per_week }
          it { is_expected.to validate_presence_of(:voluntary_hours_per_week).on(:apply) }
        end
      end

      context 'requiring projects to be accepted' do

        [:project1, :project2].each do |project_method|
          context "for #{project_method}" do
            let(:project_method) { project_method }

            def assign_project(project)
              subject.send("#{project_method}=", project)
              subject.valid? :apply
              project
            end

            it 'will not allow a pending project' do
              assign_project create(:project)
              expect(subject.errors[:projects]).to be_present
            end

            it 'will not allow a rejected project' do
              assign_project create(:project, :rejected)
              expect(subject.errors[:projects]).to be_present
            end

            it 'will allow an accepted project' do
              assign_project create(:project, :accepted)
              expect(subject.errors[:projects]).to be_blank
            end
          end
        end

      end

    end

    context 'for student attributes' do
      let(:failing_student) { double.as_null_object }

      context 'with just one student' do
        before do
          allow(subject).to receive(:students).and_return([failing_student])
        end

        Student::REQUIRED_DRAFT_FIELDS.each do |attribute|
          it "requires student0_#{attribute} for 'apply' context" do
            expect { subject.valid? :apply }.to \
              change { subject.errors["student0_#{attribute}"] }.to include "can't be blank"
          end

          context 'with proper values' do
            let(:ace_student)     { double(attribute => value).as_null_object }
            let(:value)           { SecureRandom.hex(12) }

            before do
              allow(subject).to receive(:students).and_return([ace_student])
            end

            it 'is satisfied when the corresponding student method is set' do
              expect { subject.valid? :apply }.not_to \
                change { subject.errors["student0_#{attribute}"] }
            end
          end
        end

      end

      Student::REQUIRED_DRAFT_FIELDS.each do |attribute|
        let(:ace_student)     { double.as_null_object }
        let(:value)           { SecureRandom.hex(12) }

        before do
          allow(ace_student).to receive(attribute).and_return(value)
        end

        context 'with two students' do
          context 'one being invalid' do
            before do
              allow(subject).to receive(:students).and_return([failing_student, ace_student])
            end

            it "is satisfied when the corresponding student #{attribute} is set" do
              expect { subject.valid? :apply }.not_to \
                change { subject.errors["student1_#{attribute}"] }
            end

            it "requires student0_#{attribute} for 'apply' context" do
              expect { subject.valid? :apply }.to \
                change { subject.errors["student0_#{attribute}"] }.to include "can't be blank"
            end

          end
        end

        context 'both being valid' do
          before do
            allow(subject).to receive(:students).and_return([ace_student, ace_student])
          end

          it "is satisfied when the students' #{attribute} is set" do
            expect { subject.valid? :apply }.not_to \
              change { subject.errors["student0_#{attribute}"] }
            expect { subject.valid? :apply }.not_to \
              change { subject.errors["student1_#{attribute}"] }
          end
        end
      end
    end

    context 'with character limits' do
      let(:students) { build_stubbed_list :student, 2 }
      before { allow(subject).to receive(:students).and_return(students) }

      (described_class::STUDENT0_CHAR_LIMITED_FIELDS + described_class::STUDENT1_CHAR_LIMITED_FIELDS).each do |attribute|
        it { is_expected.to allow_value("x" * (Student::CHARACTER_LIMIT + 1)).for(attribute) }
        it { is_expected.to validate_length_of(attribute).is_at_most(Student::CHARACTER_LIMIT).on(:apply) }
      end
    end
  end

  context 'with callbacks' do
    it 'sets the current season if left blank' do
      expect { subject.valid? }.to \
        change { subject.season }.from(nil).to(Season.current)
    end
  end

  describe '#projects' do
    let(:project1) { build_stubbed :project }
    let(:project2) { build_stubbed :project }

    it 'collects both projects' do
      subject.project1 = project1
      subject.project2 = project2
      expect(subject.projects).to eql [project1, project2]
    end

    it 'returns a list of nils' do
      expect(subject.projects).to eql [nil, nil]
    end
  end

  context 'with proxy methods for its students' do
    let(:student0) { Student.new }
    let(:student1) { Student.new }

    shared_examples_for 'proxies user method' do |student, attr|
      describe "##{student}_#{attr}" do
        it "returns student##{attr}" do
          value = SecureRandom.hex(16)
          expect(send(student)).to receive(attr).and_return(value)
          expect(subject.send("#{student}_#{attr}")).to eql value
        end
      end
    end

    Student::REQUIRED_DRAFT_FIELDS.each do |attribute|

      context 'with one student' do
        before { allow(subject).to receive(:students).and_return([student0]) }

        it_behaves_like 'proxies user method', :student0, attribute

        describe "#student1_#{attribute}" do
          it "returns student##{attribute}" do
            expect(subject.send("student1_#{attribute}")).to be_nil
          end
        end
      end

      context 'with two students' do
        before { allow(subject).to receive(:students).and_return([student0, student1]) }

        it_behaves_like 'proxies user method', :student0, attribute
        it_behaves_like 'proxies user method', :student1, attribute
      end

    end

    it 'proxies the setter methods' do
      attribute = "student0_#{Student::REQUIRED_DRAFT_FIELDS.sample}"
      allow(subject).to receive(:students).and_return([student0])

      expect {
        subject.send("#{attribute}=", "some value")
      }.to change { subject.send(attribute) }.to "some value"
    end
  end

  describe '#role_for' do
    let(:user) { create :user }
    let(:team) { create :team }

    subject { described_class.new team: team }

    shared_examples_for 'checks for role' do |role|
      it "returns '#{role.titleize}'" do
        create "#{role}_role", user: user, team: team
        expect(subject.role_for(user)).to eql role.titleize
      end
    end

    it_behaves_like 'checks for role', 'student'
    it_behaves_like 'checks for role', 'coach'
    it_behaves_like 'checks for role', 'mentor'
  end

  describe '#ready?' do
    it 'returns false' do
      expect(subject).not_to be_ready
    end

    it 'returns true for a nicely filled out draft' do
      subject = create(:application_draft, :appliable)
      expect(subject).to be_ready
    end
  end

  describe '#state' do
    it 'returns "draft" when applied_at is blank' do
      expect(subject).to be_draft
    end

    it 'returns "applied" when applied_at is set' do
      allow(subject).to receive(:ready?).and_return(true)
      subject.submit_application(1.day.ago)
      expect(subject).to be_applied
    end
  end

  describe '#submit_application' do
    it 'will not create an application if not valid enough' do
      expect { subject.submit_application }.to raise_error AASM::InvalidTransition
    end

    context 'with an appliable draft' do
      subject { create(:application_draft, :appliable) }

      it 'creates a new application' do
        expect { subject.submit_application }.to \
          change { Application.count }.by(1)
      end

      it 'sets the application reference on the draft' do
        expect { subject.submit_application }.to \
          change { subject.application }
      end
    end
  end

end
