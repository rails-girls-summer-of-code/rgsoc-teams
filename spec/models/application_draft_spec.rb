require 'spec_helper'

RSpec.describe ApplicationDraft do
  it_behaves_like 'HasSeason'

  context 'with associations' do
    it { is_expected.to belong_to(:updater).class_name('User') }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }

    context 'with more than one application' do
      let(:team) { create :team }
      let!(:draft) { team.application_drafts.create }

      def build_draft
        team.application_drafts.build
      end

      it 'allows the creation of a second application draft' do
        expect { build_draft.save }.to \
          change { team.application_drafts.count }.by(1)
      end

      context 'with an existing draft' do
        before { build_draft.save }

        let!(:third_draft) { build_draft }

        it 'prohibits the creation of a third application draft' do
          expect { third_draft.save }.not_to change { team.application_drafts.count }
          expect(third_draft.errors[:base]).to eql ['Only two applications may be lodged']
        end

        it 'allows drafts in different seasons' do
          third_draft.season = create(:season, name: 2000)
          expect { third_draft.save }.to change { team.application_drafts.count }.by(1)
        end
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

      it_behaves_like 'proxies :apply validation', :project_name
      it_behaves_like 'proxies :apply validation', :project_url
      it_behaves_like 'proxies :apply validation', :project_plan
      it_behaves_like 'proxies :apply validation', :heard_about_it

      context 'required fields for voluntary mode' do
        it { is_expected.not_to validate_presence_of :voluntary_hours_per_week }
        it { is_expected.not_to validate_presence_of(:voluntary_hours_per_week).on(:apply) }

        context 'with voluntary set to true' do
          before { subject.voluntary = true }
          it { is_expected.not_to validate_presence_of :voluntary_hours_per_week }
          it { is_expected.to validate_presence_of(:voluntary_hours_per_week).on(:apply) }
        end
      end

      context 'requiring a mentor' do
        it 'complains about a missing role' do
          error_msg = 'You need at least one mentor on your team'
          expect { subject.valid?(:apply) }.to \
            change { subject.errors[:base] }.to match_array error_msg
        end

        it 'requires a mentor' do
          subject.team = create(:mentor_role).team
          expect { subject.valid?(:apply) }.not_to change { subject.errors[:base] }
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

    context 'for coaches\' attributes' do
      before { allow(subject).to receive(:students).and_return [] }

      it { is_expected.not_to validate_presence_of :coaches_hours_per_week }
      it { is_expected.not_to validate_presence_of :coaches_why_team_successful }

      context 'when applying' do
        it { is_expected.to validate_presence_of(:coaches_hours_per_week).on(:apply) }
        it { is_expected.to validate_presence_of(:coaches_why_team_successful).on(:apply) }
      end
    end
  end

  context 'with callbacks' do
    it 'sets the current season if left blank' do
      expect { subject.valid? }.to \
        change { subject.season }.from(nil).to(Season.current)
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
