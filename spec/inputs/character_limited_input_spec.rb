require 'rails_helper'

RSpec.describe CharacterLimitedInput do
  include RSpec::Rails::HelperExampleGroup

  describe '#input' do
    let(:input) { proc { |f| f.input(:attr_name, as: :character_limited) } }

    subject { helper.simple_form_for(:foo, url: '', &input) }

    it 'returns a textarea with character-limited data attributes' do
      tag_attributes = {
        'data-behaviour' => 'character-limited',
        'data-maxlength' => Student::CHARACTER_LIMIT,
        'class'          => 'form-control character_limited required',
        'name'           => 'foo[attr_name]'
      }

      expect(subject).to have_tag('textarea', with: tag_attributes)
    end

    it 'does not use the html maxlength attribute' do
      expect(subject).not_to include ' maxlength='
    end

    it 'returns a counter element' do
      expect(subject).to have_tag('p') do
        with_tag('span', with: { class: 'character_limited_counter' })
      end
    end
  end
end
