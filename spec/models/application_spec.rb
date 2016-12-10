require 'spec_helper'

describe Application do
  subject { FactoryGirl.build(:application) }

  it { is_expected.to validate_presence_of(:application_data) }
  it { is_expected.to validate_presence_of(:team) }

  context 'with associations' do
    it { is_expected.to belong_to(:team).inverse_of(:applications).counter_cache(true) }
    it { is_expected.to belong_to(:project) }
    it { is_expected.to belong_to(:application_draft) }
    it { is_expected.to belong_to(:application_draft) }
    it { is_expected.to belong_to(:signatory).with_foreign_key(:signed_off_by) }
    it { is_expected.to have_many(:comments).dependent(:destroy).order(:created_at) }
    it { is_expected.to have_many(:ratings) }
  end

  describe '#average_skill_level' do
    subject { super().average_skill_level }
    it { is_expected.to be_present }
  end

  describe '#total_picks' do
    subject { super().total_picks }
    it { is_expected.to be_present }
  end

  describe '#name' do
    it 'returns an empty string' do
      subject.team = nil
      subject.project = nil
      expect(subject.name).to eql ''
    end

    it 'derives its name from its team and project' do
      subject.team = build_stubbed(:team, name: 'Foobar')
      subject.project = build_stubbed(:project, name: 'Hello World')

      expect(subject.name).to eql 'Foobar - Hello World'
    end
  end

  it { is_expected.to respond_to(:sponsor_pick?) }

  it_behaves_like 'HasSeason'

  describe 'scopes' do
    describe '.hidden' do
      it 'returns only hidden applications' do
        expect(Application.hidden.where_clause.send(:predicates)).to eq(
          ["applications.hidden IS NOT NULL and applications.hidden = 't'"]
        )
      end
    end

    describe '.visible' do
      it 'returns only visible applications' do
        expect(Application.visible.where_clause.send(:predicates)).to eq(
          ["applications.hidden IS NULL or applications.hidden = 'f'"]
        )
      end
    end
  end

  describe 'flags' do
    flags = Application::FLAGS

    flags.each do |flag|
      it { is_expected.to respond_to("#{flag}?") }
      it { is_expected.to respond_to("#{flag}=") }
    end

    it 'adds the flag if the value is > 0' do
      flag = flags.sample.to_s
      expect(subject.flags).to be_empty

      subject.send("#{flag}=", '1')
      expect(subject.flags).to include(flag)
    end

    it 'removes the flag if the value is 0' do
      flag = flags.sample.to_s
      subject.send(:"#{flag}=", '1')
      expect(subject.flags).to include(flag)
      subject.send(:"#{flag}=", '0')
      expect(subject.flags).not_to include(flag)
    end
  end

  describe 'student_name' do
    let(:team)    { FactoryGirl.build(:team, students: [student]) }
    let(:student) { FactoryGirl.build(:student) }

    before { allow(subject).to receive(:team).and_return(team) }

    it { expect(subject.student_name).to eq student.name }
  end

  describe 'proxy methods' do
    proxy_methods = %w(location minimum_money)

    proxy_methods.each do |key|
      describe key do
        it { expect(subject.send(key)).to be_present }
        it { expect(subject.send(key)).to eq subject.application_data[key] }
      end
    end
  end

  describe 'sponsor pick' do
    application = FactoryGirl.create(:application)
    it 'does not have a sponsor' do
      expect(application.sponsor_pick?).to eql false
    end
  end
end
