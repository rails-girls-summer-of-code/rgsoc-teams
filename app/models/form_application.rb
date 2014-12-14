class FormApplication < ActiveRecord::Base
  include ActiveModel::Serialization
  include ActiveModel::Conversion

  has_one :application, dependent: :destroy
  FIELDS = [:name, :email, :project_name, :about_student, :location, :attended_rg_workshop, :coding_level, :skills, :learning_summary]


  def fields
    FIELDS
  end
end