require 'spec_helper'

describe ApplicationFormHelper do
  describe '.time_span_array' do
    it 'returns an array of timespans' do
      expect(time_span_array.size).to eq(6)
    end
  end
end
