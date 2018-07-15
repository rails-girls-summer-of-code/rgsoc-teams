require 'rails_helper'

RSpec.describe Season, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
    it { is_expected.to allow_value('2017').for(:name) }
    it { is_expected.not_to allow_value('20177').for(:name) }
    it { is_expected.not_to allow_value('201').for(:name) }
    it { is_expected.not_to allow_value('201o').for(:name) }
  end

  describe 'associations' do
    it { is_expected.to have_many(:projects) }
  end

  describe 'callbacks' do
    subject { described_class.new name: Date.today.year }

    describe 'before validation' do
      it 'sets starts_at' do
        expect { subject.valid? }.to change { subject.starts_at }.from nil
      end

      it 'sets ends_at' do
        expect { subject.valid? }.to change { subject.ends_at }.from nil
      end

      it 'sets acceptance_notification_at to the end of day' do
        date = DateTime.parse('2015-02-22 14:00 GMT+1')
        subject.acceptance_notification_at = date
        expect { subject.valid? }.to \
          change { subject.acceptance_notification_at }.to \
          DateTime.parse('2015-02-22 23:59:59.999999999 GMT')
      end

      it 'sets the project_proposals_open_at to the beginning of the day' do
        date = DateTime.parse('2015-02-22 14:00 GMT+1')
        subject.project_proposals_open_at = date
        expect { subject.valid? }.to \
          change { subject.project_proposals_open_at }.to \
          DateTime.parse('2015-02-22 0:00 UTC')
      end

      it 'sets the project_proposals_close_at to the end of the day' do
        date = DateTime.parse('2015-02-22 14:00 GMT+1')
        subject.project_proposals_close_at = date
        expect { subject.valid? }.to \
          change { subject.project_proposals_close_at }.to \
          DateTime.parse('2015-02-22 23:59:59.999999999 GMT')
      end
    end
  end

  describe '#ended?' do
    it 'returns true if ended_at is not set' do
      expect(Season.new).not_to be_ended
    end

    context 'in the midst of the season' do
      it 'returns false' do
        Timecop.travel(Season.current.starts_at + 1.week) do
          expect(Season.current).not_to be_ended
        end
      end
    end

    context 'after the season' do
      it 'returns true' do
        Timecop.travel(Season.current.ends_at + 1.week) do
          expect(Season.current).to be_ended
        end
      end
    end

    context 'on the last day of the season' do
      subject { Season.new(ends_at: Date.today) }
      it 'returns false' do
        Timecop.travel(subject.ends_at + 4.hours) do
          expect(subject).not_to be_ended
        end
      end
    end
  end

  describe '#application_period?' do
    it 'returns true if today is between open and close date' do
      subject.applications_open_at = 1.week.ago
      subject.applications_close_at = 1.week.from_now
      expect(subject).to be_application_period
    end

    it 'returns false if today is before open date' do
      subject.applications_open_at = 1.day.from_now
      subject.applications_close_at = 1.week.from_now
      expect(subject).not_to be_application_period
    end

    it 'returns false if today is after close date' do
      subject.applications_open_at = 1.week.ago
      subject.applications_close_at = 1.day.ago
      expect(subject).not_to be_application_period
    end
  end

  describe '#applications_open?' do
    it 'returns true if today is past application open date' do
      subject.applications_open_at = 1.week.ago
      expect(subject).to be_applications_open
    end

    it 'returns false' do
      expect(subject).not_to be_applications_open
    end
  end

  describe '#started?' do
    it 'returns true if today is past starts_at' do
      subject.starts_at = 1.week.ago
      expect(subject).to be_started
    end

    it 'returns false' do
      expect(subject).not_to be_started
    end
  end

  describe '#year' do
    it 'returns the name' do
      subject.name = 'foobarbaz'
      expect(subject.year).to eql 'foobarbaz'
    end
  end

  describe '#current?' do
    subject { described_class.new(name: year) }

    context 'in a past year' do
      let(:year) { Date.today.year - 1 }
      it { is_expected.not_to be_current }
    end

    context 'in the same year' do
      let(:year) { Date.today.year }
      it { is_expected.to be_current }
    end

    context 'in a future year' do
      let(:year) { Date.today.year + 1 }
      it { is_expected.not_to be_current }
    end
  end

  describe '.current' do
    it 'creates a season record' do
      create :season, name: '2000'
      expect { Season.current }.to \
        change { Season.count }.by(1)
    end

    it 'returns the existing season' do
      season = create :season, name: Date.today.year
      expect(Season.current).to eql season
    end
  end

  describe '.succ' do
    subject { Season.succ }
    let(:year) { Date.today.year }

    context 'with existing successor season' do
      let!(:next_season) { Season.create name: year + 1 }

      it 'returns the existing follow-up season' do
        expect { subject }.not_to change { Season.count }
        expect(subject).to eql next_season
      end
    end

    it 'creates the successor if it doesn\'t exist' do
      expect { subject }.to change { Season.count }.by(1)
      expect(subject.name).to eql (year + 1).to_s
    end

    it 'sets the dates into the following year' do
      expect(subject.starts_at.year).to eql year + 1
      expect(subject.ends_at.year).to eql year + 1
      expect(subject.applications_open_at.year).to eql year + 1
      expect(subject.applications_close_at.year).to eql year + 1
    end
  end

  describe '.transition?' do
    subject { Season }

    context 'during mid-summer' do
      before { Timecop.travel Date.parse('2015-08-01') }
      it { is_expected.not_to be_transition }
    end

    context 'right after the summer has ended' do
      before { Timecop.travel Date.parse('2015-10-01') }
      it { is_expected.to be_transition }
    end

    context 'on New Year\'s' do
      before { Timecop.travel Date.parse('2016-01-01') }
      it { is_expected.not_to be_transition }
    end
  end

  describe '.projects_proposable?' do
    subject { described_class }

    context 'during transition phase' do
      context 'before project proposals open date' do
        before { Timecop.travel Date.parse('2015-11-15') }
        it { is_expected.not_to be_projects_proposable }
      end

      context 'after project proposals open date' do
        before { Timecop.travel Date.parse('2015-12-15') }
        it { is_expected.to be_projects_proposable }
      end
    end

    context 'at the beginning of a new year' do
      context 'after project proposals open date' do
        before { Timecop.travel Date.parse('2016-01-10') }
        it { is_expected.to be_projects_proposable }
      end
    end
  end

  describe '.active_and_previous_years' do
    it 'returns array of years that includes all active and previously active years in reverse chronological order' do
      next_year = (Date.today.year + 1).to_s
      create :season, name: '2015'
      create :season, name: '2017'
      create :season, name: '2016'
      create :season, name: next_year
      expect(Season.active_and_previous_years).to eq ['2017', '2016', '2015']
    end

    it 'returns current year only if current season is active season' do
      before_acceptance_notification = Time.utc(2018, 5, 1, 23, 59, 58)
      after_acceptance_notification = Time.utc(2018, 5, 2, 0, 0, 0)
      create :season, name: '2015'
      create :season, name: '2016'
      create :season, name: '2018'

      Timecop.freeze(before_acceptance_notification) do
        expect(Season.active_and_previous_years).to eq ['2016', '2015']
      end

      Timecop.freeze(after_acceptance_notification) do
        expect(Season.active_and_previous_years).to eq ['2018', '2016', '2015']
      end
    end
  end
end
