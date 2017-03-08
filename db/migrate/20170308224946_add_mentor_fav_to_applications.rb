class AddMentorFavToApplications < ActiveRecord::Migration[5.0]
  def change
    add_column :applications, :mentor_fav, :boolean
  end
end
