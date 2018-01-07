require 'rails_helper'

RSpec.describe CityInput do
  include RSpec::Rails::HelperExampleGroup

  describe '#input' do
    let(:input) { proc { |f| f.input(:attr_name, as: :city) } }

    subject { helper.simple_form_for(:foo, url: '', &input) }

    it 'returns a text input with autocomplete' do
      expect(subject).to include(
        'data-behavior="city-autocomplete" type="text" name="foo[attr_name]"'
      )
    end

    it 'returns a hidden input for lat' do
      expect(subject).to include(
        'data-behavior="location-lat" type="hidden" name="foo[attr_name_lat]"'
      )
    end

    it 'returns a hidden input for lng' do
      expect(subject).to include(
        'data-behavior="location-lng" type="hidden" name="foo[attr_name_lng]"'
      )
    end
  end
end
