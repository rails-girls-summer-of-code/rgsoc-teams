require 'spec_helper'

RSpec.describe ApplicationDraft do
  it_behaves_like 'HasSeason'

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }

    context 'for coaches\' attributes' do
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
