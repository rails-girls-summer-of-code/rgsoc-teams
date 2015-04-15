class AddAcceptanceNotificationAtToSeasons < ActiveRecord::Migration
  def change
    add_column :seasons, :acceptance_notification_at, :datetime
  end
end
