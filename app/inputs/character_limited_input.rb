class CharacterLimitedInput < SimpleForm::Inputs::TextInput
  def input_html_options
    super.merge(maxlength: Student::CHARACTER_LIMIT)
  end

  def input(wrapper_options)
    [super, counter].join("\n").html_safe
  end

  private

  def counter
    chars_left  = Student::CHARACTER_LIMIT - @builder.object.send(attribute_name).size
    num_element = content_tag(:span, chars_left, class: 'character_limited_counter')

    content_tag(:p, "#{num_element} character(s) left".html_safe)
  end
end
