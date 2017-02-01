class AdaptHeardAboutItToArray < ActiveRecord::Migration[5.0]
  def up
    change_column :application_drafts, :heard_about_it, :string, array: true, default: [], using: "(string_to_array(heard_about_it, ','))"
  end

  def down
    change_column :application_drafts, :heard_about_it, :string
  end
end
