class RenameUserNameOnRatings < ActiveRecord::Migration
  def change
    remove_column :ratings, :user_name
    add_column :ratings, :user_id, :integer
  end
end
