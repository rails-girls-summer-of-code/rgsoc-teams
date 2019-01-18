# frozen_string_literal: true

class CityInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options)
    super << lat_field << lng_field
  end

  def input_html_options
    super.merge(data: { behavior: 'city-autocomplete' })
  end

  private

  def lat_field
    location_field(:lat)
  end

  def lng_field
    location_field(:lng)
  end

  def location_field(coord_type)
    params = field_attrs(coord_type)
    @builder.hidden_field(*params)
  end

  def field_attrs(coord_type)
    attr_name = [attribute_name, coord_type].join('_')
    data      = { data: { behavior: "location-#{coord_type}" } }
    [attr_name, data]
  end
end
