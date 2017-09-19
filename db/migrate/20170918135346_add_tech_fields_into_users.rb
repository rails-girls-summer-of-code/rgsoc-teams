class AddTechFieldsIntoUsers < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :tech_expertise, :text, array: true, default: []
    add_column :users, :tech_interest, :text, array: true, default: []
  end

  def down
    remove_column :users, :tech_expertise
    remove_column :users, :tech_interest
  end
end
