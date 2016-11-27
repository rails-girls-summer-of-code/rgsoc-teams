require 'spec_helper'

RSpec.describe Conference do
  it_behaves_like 'HasSeason'

  describe 'dependencies' do
    subject { FactoryGirl.build(:conference) }

    it { is_expected.to have_many(:attendances) }
    it { is_expected.to have_many(:attendees) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:round) }
    # The custom date validator is tested in test 'chronology', below
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

  describe 'chronology' do
    subject { FactoryGirl.build(:conference) }

    context 'when the dates are in the right order' do
      it 'is valid' do
        subject.starts_on = '2016-11-20'
        subject.ends_on = '2016-11-21'
        expect(subject).to be_valid
      end
    end

    context 'when its end date is before start date' do
      it 'is invalid' do
        subject.starts_on = '2016-07-15'
        subject.ends_on = '2016-07-07'
        expect(subject).not_to be_valid
      end
    end
  end

  describe '#tickets_left' do

    context 'ticket value defined' do
      let(:attendance)    { FactoryGirl.build(:attendance, confirmed: true) }
      subject { FactoryGirl.build_stubbed(:conference, tickets: 2) }
      it 'subtracts attendances' do
        allow(subject).to receive(:attendances).and_return([attendance])
        left_tickets = subject.tickets - subject.attendances.size
        expect(subject.tickets_left).to eq(left_tickets)
      end
    end

    context 'tickets value not defined' do
      subject { FactoryGirl.build_stubbed(:conference, tickets: nil) }
      it 'returns 0' do
        allow(subject).to receive(:attendances).and_return([])
        expect(subject.tickets_left).to eq(0)
      end
    end
  end
end