class CharacterLimitedInput < SimpleForm::Inputs::TextInput
  def input_html_options
    super.merge(maxlength: Student::CHARACTER_LIMIT)
  end

  def input(wrapper_options)
    [super, counter].join("\n").html_safe
  end

  private

  def counter
    content_tag(:span, "0")
  end
end
