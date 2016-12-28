require 'spec_helper'

RSpec.describe Conference do
  it_behaves_like 'HasSeason'

    it { is_expected.to have_many(:attendances) }
    it { is_expected.to have_many(:attendees) }
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:round) }
    # The custom date validator is tested in test 'chronology', below

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

    context 'when its end date is earlier than its start date' do
      it 'raises an error' do
        subject.starts_on = '2016-07-15'
        subject.ends_on = '2016-07-07'
        expect(subject).to have(1).error_on(:ends_on)
      end
    end

    context 'when the dates are in the right order' do
      it 'raises no errors' do
        subject.starts_on = '2016-11-20'
        subject.ends_on = '2016-11-21'
        expect(subject).to have(:no).errors_on(:ends_on)
      end
    end

    context 'when start date is nil' do

      before do
        subject.starts_on = nil
      end

      it 'the end date can be nil as well' do
        expect(subject).to allow_value(nil).for(:ends_on)
        expect(subject).to have(:no).errors_on(:ends_on)
        expect(subject).to have(:no).errors_on(:base)
      end

      it 'there can not be an end date' do
        subject.ends_on = '2016-07-15'
        expect(subject).to have(1).error_on(:base)
      end
    end

    context 'when the end date is nil' do
      it 'does not allow a start date' do
        subject.starts_on = Date.today
        subject.ends_on = nil
        expect(subject).to have(1).error_on(:base)
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