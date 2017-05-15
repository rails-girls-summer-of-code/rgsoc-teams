require 'spec_helper'

RSpec.describe Conference do
  it_behaves_like 'HasSeason'

  it { is_expected.to have_many(:attendances).dependent(:destroy) }
  it { is_expected.to have_many(:attendees) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_presence_of(:round) }
  it { is_expected.to validate_presence_of(:starts_on) }
  it { is_expected.to validate_presence_of(:ends_on) }

  describe 'it checks the chronological order of dates' do
    subject { FactoryGirl.build(:conference) }
    it 'raises an error with an incorrect order of dates' do
      subject.starts_on = '2017-07-15'
      subject.ends_on = '2017-07-07'
      expect(subject).to have(1).error_on(:ends_on)
    end

    it 'accepts the dates when in the right order' do
      subject.starts_on = '2017-07-07'
      subject.ends_on = '2017-07-07'
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
