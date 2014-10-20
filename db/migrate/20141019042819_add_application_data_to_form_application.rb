class AddApplicationDataToFormApplication < ActiveRecord::Migration
  def change
    add_column :form_applications, :application_data, :hstore
  end
end
