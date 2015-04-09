require 'spec_helper'

describe Season do
  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }
  end

  context 'with callbacks' do
    context 'before validation' do
      it 'sets applications_open_at to the beginning of day' do
        date = DateTime.parse('2015-02-22 14:00 GMT+1')
        subject.applications_open_at = date
        expect { subject.valid? }.to \
          change { subject.applications_open_at }.to \
          DateTime.parse('2015-02-22 0:00 UTC')
      end

      it 'sets applications_close_at to the end of day' do
        date = DateTime.parse('2015-02-22 14:00 GMT+1')
        subject.applications_close_at = date
        expect { subject.valid? }.to \
          change { subject.applications_close_at }.to \
          DateTime.parse('2015-02-22 23:59:59 GMT')
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

end
