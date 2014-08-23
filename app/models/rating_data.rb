class RatingData
  include ActiveModel::Validations
  include ActiveModel::Conversion
  include ActiveModel::Serialization

  extend ActiveModel::Naming

  FIELDS = [
    :women_priority, :skill_level, :practice_time,
    :project_time, :support, :planning, :bonus
  ]

  attr_accessor *FIELDS

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end
end
