require 'spec_helper'

RSpec.describe ApplicationDraft do
  it_behaves_like 'HasSeason'

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }

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
          let(:ace_student_2)   { double.as_null_object }
          let(:value_2)         { SecureRandom.hex(12)  }

          before do
            allow(subject).to receive(:students).and_return([ace_student, ace_student_2])
            allow(ace_student_2).to receive(attribute).and_return(value_2)
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
  end

end
