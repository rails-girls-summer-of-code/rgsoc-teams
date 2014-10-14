class AddProjectToFormApplication < ActiveRecord::Migration
  def change
    add_column :form_applications, :project, :string
  end
end
