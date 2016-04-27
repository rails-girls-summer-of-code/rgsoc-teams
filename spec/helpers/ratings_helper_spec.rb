require 'spec_helper'

describe RatingsHelper do
  describe '#rounded_points_for' do
    context 'when object is rateable' do
      let(:rateable) { double() }
      before { allow(rateable).to receive(:average_points){ 0.123456789 } }

      context 'without precision parameter' do
        it 'returns average_points with 2 decimals precision' do
          expect(rounded_points_for rateable).to eq 0.12
        end
      end
      context 'with precision parameter' do
        it 'retuns average_points with specified precision' do
          expect(rounded_points_for rateable, 4).to eq 0.1235
        end
      end
    end
  end
  context 'when object is rating' do
    let(:rate) { double() }

    context 'with points value' do
      before { allow(rate).to receive(:points){ 0.123456789 } }

      context 'without precision parameter' do
        it 'returns points with 2 decimals precision' do
          expect(rounded_points_for rate).to eq 0.12
        end
      end
      context 'with precision parameter' do
        it 'retuns points with specified precision' do
          expect(rounded_points_for rate, 4).to eq 0.1235
        end
      end
    end
    context 'without points value (no values set)' do
      before { allow(rate).to receive(:points) }

      it 'retuns nil' do
        expect(rounded_points_for rate).to eq nil
      end
    end
  end
end
