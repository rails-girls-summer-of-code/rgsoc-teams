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

    it 'has _<field>_options method to return array for multiple choice options' do
      RatingData::FIELDS.keys.each do |key|
        expect(rating_data).to respond_to "#{key}_options"
        expect(rating_data.send "#{key}_options").to be_an Array
      end
    end

    it '_<field>_options method returns array for multiple choice options' do
      expect(rating_data.ambitions_options).to be_an Array
    end
  end
end
