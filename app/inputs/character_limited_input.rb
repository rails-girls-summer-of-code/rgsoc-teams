# frozen_string_literal: true

class CharacterLimitedInput < SimpleForm::Inputs::TextInput
  def input_html_options
    super.merge(data: { behaviour: 'character-limited', maxlength: Student::CHARACTER_LIMIT })
  end

  def input(wrapper_options)
    [super, counter].join("\n").html_safe
  end

  private

  def counter
    num_element = content_tag(:span, 0, class: 'character_limited_counter')
    content_tag(:p, "#{num_element} character(s) left".html_safe)
  end
end
