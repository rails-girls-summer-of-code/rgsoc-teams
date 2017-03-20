class RenameMentorFavFromApplications < ActiveRecord::Migration[5.0]
  def up
    rename_column :applications, :mentor_fav, :deprecated_mentor_fav
  end

  def down
    rename_column :applications, :deprecated_mentor_fav, :mentor_fav
  end
end
