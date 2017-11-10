require 'spec_helper'

describe Conference do
  it_behaves_like 'HasSeason'

  it { is_expected.to have_many(:conference_attendances).dependent(:destroy) }
  it { is_expected.to have_many(:first_choice_conference_preferences) }
  it { is_expected.to have_many(:second_choice_conference_preferences) }
  it { is_expected.to have_many(:attendees).through(:second_choice_conference_preferences) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:url) }
  it { is_expected.to validate_presence_of(:city) }
  it { is_expected.to validate_presence_of(:country) }
  it { is_expected.to validate_presence_of(:region) }

  describe 'validates chronological dates' do
    subject { build(:conference) }
    let(:start_date) { subject.starts_on }

    it 'with an incorrect order of dates it raises an error' do
      subject.ends_on = start_date - 1.week
      expect(subject).not_to be_valid
      expect(subject.errors[:ends_on]).not_to be_empty
    end

    it 'when in the right order' do
      subject.ends_on = start_date + 1.week
      expect(subject).to be_valid
      expect(subject.errors[:ends_on]).to be_empty
    end
  end

  describe 'scopes' do
    subject { Conference }

    describe '.ordered' do
      it 'queries with a specific default order' do
        expect(subject.ordered.order_values).to eq(['starts_on, name asc'])
      end

      it 'takes a sort hash' do
        expect(subject.ordered(order: 'name').order_values).to eq(['name asc'])
        expect(subject.ordered(direction: 'desc').order_values).to eq(['starts_on, name desc'])
      end
    end
  end

  describe '#date_range' do
    subject { build_stubbed(:conference) }

    it 'has a date range' do
      expect(subject.date_range).to be_a(DateRange)
    end
  end

  describe '#tickets_left' do

    context 'ticket value defined' do
      let(:conference_preference) { build(:conference_preference, confirmed: true) }
      subject { build_stubbed(:conference, tickets: 2) }

      it 'subtracts conference preferences' do
        allow(subject).to receive(:conference_preference).and_return([conference_preference])
        left_tickets = subject.tickets - subject.conference_preference.size
        expect(subject.tickets_left).to eq(left_tickets)
      end
    end

    context 'tickets value not defined' do
      subject { build_stubbed(:conference, tickets: nil) }

      it 'returns 0' do
        allow(subject).to receive(:conference_preference).and_return([])
        expect(subject.tickets_left).to eq(0)
      end
    end
  end
end
