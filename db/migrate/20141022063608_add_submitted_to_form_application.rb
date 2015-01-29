class AddSubmittedToFormApplication < ActiveRecord::Migration
  def change
    add_column :form_applications, :submitted, :boolean
  end
end
