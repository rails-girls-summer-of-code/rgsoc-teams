class UpdateUserNamesIfEmpty < ActiveRecord::Migration
  def change
    User.where("name = ? OR name IS NULL", '').update_all("name = github_handle")
  end
end
