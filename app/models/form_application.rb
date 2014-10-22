class FormApplication < ActiveRecord::Base
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  belongs_to :application
  FIELDS = [:name, :email, :project_name, :about_student, :location, :attended_rg_workshop, :coding_level, :skills, :learning_summary]


  def fields
    FIELDS
  end


  def set_number
    self.number = FormApplication.count + 1
  end
end

