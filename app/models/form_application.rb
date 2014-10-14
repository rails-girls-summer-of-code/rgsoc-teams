class FormApplication < ActiveRecord::Base

  FIELDS = [:name, :email, :project, :about, :location, :attended_rg_ws, :coding_level, :skills, :learning_summary]

  def display_name
     project
  end

  def fields
    FIELDS
  end


  def set_number
    self.number = FormApplication.count + 1
  end
end

