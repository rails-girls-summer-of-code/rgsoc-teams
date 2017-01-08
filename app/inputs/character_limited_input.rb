class CharacterLimitedInput < SimpleForm::Inputs::TextInput
  def input_html_options
    super.merge(maxlength: Student::CHARACTER_LIMIT)
  end

  def input(wrapper_options)
    [super, counter].join("\n").html_safe
  end

  private

  def counter
    value = @builder.object.send(attribute_name).size
    content_tag(:span, value)
  end
end
