class CityInput < SimpleForm::Inputs::StringInput
  def input_html_options
    super.merge(data: { behavior: 'city-autocomplete' })
  end
end
