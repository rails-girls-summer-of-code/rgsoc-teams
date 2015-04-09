class RemoveUserSpecificColumnsFromApplications < ActiveRecord::Migration
  def up
    remove_column :applications, :email
    remove_column :applications, :name
    remove_column :applications, :user_id
  end

  def down
    add_column :applications, :email,   :string
    add_column :applications, :name,    :string
    add_column :applications, :user_id, :integer

    add_index :applications, :user_id
  end
end
