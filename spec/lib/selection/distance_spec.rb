require 'rails_helper'
require 'selection/distance'

RSpec.describe Selection::Distance do
  let(:from) { ['30.1279442', '31.3300184'] }
  let(:to)   { ['30.0444196', '31.2357116000001'] }

  # Validate via geocoder gem or web service
  # see here: http://boulter.com/gps/distance/?from=30.1279442+31.3300184&to=30.0444196+31.2357116000001&units=k#more
  subject { described_class.new(from, to) }

  context 'when passing valid strings as input data' do
    it 'calcuates the distance between two lat-lng coords in meters' do
      expect(subject.to_m).to eq 12984
    end

    it 'calculates the distance between two lat-lng coords in km' do
      expect(subject.to_km).to eq 12
    end
  end

  context 'when passing nil as input data' do
    let(:to)   { [nil, nil] }

    it 'raises a no method error' do
      expect { subject }.to raise_error NoMethodError
    end
  end

  context 'when passing blank strings as input data' do
    let(:to) { ['', ''] }

    it 'calculates the distance to zero' do
      expect(subject.to_km).to eq 4711
    end
  end
end
