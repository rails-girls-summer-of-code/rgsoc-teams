class AddCommunicationOptInToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :opted_in_newsletter, :boolean, default: false
    add_column :users, :opted_in_announcements, :boolean, default: false
    add_column :users, :opted_in_marketing_announcements, :boolean, default: false
    add_column :users, :opted_in_surveys, :boolean, default: false
    add_column :users, :opted_in_sponsorships, :boolean, default: false
    add_column :users, :opted_in_applications_open, :boolean, default: false
  end
end
