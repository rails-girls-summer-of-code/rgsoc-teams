class RemoveMentorFavFromApplications < ActiveRecord::Migration[5.1]
  def change
    remove_column :applications, :deprecated_mentor_fav, :boolean
  end
end
