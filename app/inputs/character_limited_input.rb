class CharacterLimitedInput < SimpleForm::Inputs::TextInput
  def input_html_options
    super.merge(maxlength: Student::CHARACTER_LIMIT)
  end
end
