class FormApplication < ActiveRecord::Base

  FIELDS = [:name, :email, :about, :location, :attended_rg_ws, :coding_level, :skills, :learning_summary]

  attr_accessor *FIELDS

  #validates_presence_of *MUST_FIELDS

  def initialize(attributes = {})
    attributes.each do |name, value|
      send("#{name}=", value)
    end
  end

  def persisted?
    false
  end

  def fields
    FIELDS
  end

  def attributes
    fields.inject({}) { |result, field| result[field] = self.send(field); result }
  end

  def set_number
    self.number = FormApplication.count + 1
  end
end

