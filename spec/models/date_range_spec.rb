require 'rails_helper'

RSpec.describe DateRange, type: :model do
  describe '#to_s' do
    let(:start_date) { Date.parse('2015-12-31') }
    let(:end_date)   { Date.parse('2015-12-31') }

    subject { described_class.new(start_date: start_date, end_date: end_date).to_s }

    context 'depending on date range' do
      it 'returns a single day' do
        expect(subject).to eq ('31 Dec 2015')
      end

      context 'when multiple dates in same month' do
        let(:start_date) { Date.parse('2015-12-30') }

        it 'returns combined dates' do
          expect(subject).to eq ('30 - 31 Dec 2015')
        end
      end

      context 'when multiple dates in different months' do
        let(:start_date) { Date.parse('2015-11-30') }
        let(:end_date)   { Date.parse('2015-12-01') }

        it 'displays the year only once' do
          expect(subject).to eq ('30 Nov - 1 Dec 2015')
        end
      end

      context 'when multiple dates around New Year' do
        let(:end_date) { Date.parse('2016-01-01') }

        it 'returns full dates' do
          expect(subject).to eq ('31 Dec 2015 - 1 Jan 2016')
        end
      end

      context 'when same months, different years' do
        let(:end_date) { Date.parse('2016-12-01') }

        it 'returns full dates' do
          expect(subject).to eq ('31 Dec 2015 - 1 Dec 2016')
        end
      end
    end
  end
end
