class ActivitiesAddImgUrl < ActiveRecord::Migration
  def change
    add_column :activities, :img_url, :string
  end
end
