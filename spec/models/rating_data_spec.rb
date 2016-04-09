require 'spec_helper'

describe RatingData do
  describe 'FIELDS constant' do
    subject(:fields) { RatingData::FIELDS }

    it 'returns the same for symbol and string key' do
      expect(fields.values_at :bonus, 'bonus').to all eq 'numeric'
    end
  end
  describe 'attributes' do
    subject(:rating_data) { RatingData.new }

    it 'has getters and setters for all defined FIELDS keys' do
      RatingData::FIELDS.keys.each do |key|
        expect(rating_data).to respond_to key
        expect(rating_data).to respond_to "#{key}="
      end
    end

    it 'has _<field>_options for multiple choice options (not implemented yet)'
  end
  describe '.points_for' do
    context 'with invalid :field_name' do
      it 'raises ArgumentError' do
        expect{
          RatingData.points_for field_name: :invalid_key, id_picked: 1
        }.to raise_error ArgumentError
      end
    end
    context 'with valid :field_name' do
      it 'returns nil for invalid :id_picked' do
        expect(RatingData.points_for field_name: :women_priority, id_picked: 1000).to eq nil
      end

      it 'returns points for valid :id_picked' do
        expect(RatingData.points_for field_name: :women_priority, id_picked: 0).to eq RatingData::FIELDS[:women_priority].first[:points]
      end

      it 'returns :id_picked for numeric fields' do
        expect(RatingData.points_for field_name: :bonus, id_picked: 10).to eq 10
      end
    end
  end
end
