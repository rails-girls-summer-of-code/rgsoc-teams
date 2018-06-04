require 'rails_helper'

RSpec.describe Conference, type: :model do
  it_behaves_like 'HasSeason'

  describe 'associations' do
    it { is_expected.to have_many(:conference_attendances).dependent(:destroy) }
    it { is_expected.to have_many(:first_choice_conference_preferences).dependent(:destroy) }
    it { is_expected.to have_many(:second_choice_conference_preferences).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:url) }
    it { is_expected.to validate_presence_of(:city) }
    it { is_expected.to validate_presence_of(:country) }
    it { is_expected.to validate_presence_of(:region) }

    describe 'ends_on and starts_on times' do
      subject(:conference) { build(:conference, **dates) }

      let(:yesterday) { 1.day.ago }
      let(:today)     { yesterday + 1.day }
      let(:tomorrow)  { today + 1.day }
      let(:dates)     { { starts_on: today, ends_on: tomorrow } }

      it { is_expected.to be_valid }

      context 'when ends_on is before starts_on' do
        let(:dates) { { starts_on: today, ends_on: yesterday } }

        it 'is invalid' do
          expect(conference).not_to be_valid
          expect(conference.errors[:ends_on]).not_to be_empty
        end
      end

      context 'when the conference is only one day' do
        let(:dates) { { starts_on: today, ends_on: today } }

        it { is_expected.to be_valid }
      end

      # TODO: remove this once the factories don't include dates any more
      context 'without ends_on and starts_on dates' do
        let(:dates) { { starts_on: nil, ends_on: nil } }

        it { is_expected.to be_valid }
      end

      context 'without only a starts_on date' do
        let(:dates) { { starts_on: Time.current, ends_on: nil } }

        it { is_expected.to be_valid }
      end
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
end
