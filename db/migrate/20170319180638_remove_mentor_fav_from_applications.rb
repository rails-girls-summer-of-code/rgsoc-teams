class RemoveMentorFavFromApplications < ActiveRecord::Migration[5.0]
  def up
    remove_column :applications, :mentor_fav
  end

  def down
    add_column :applications, :mentor_fav, :boolean
  end
end
