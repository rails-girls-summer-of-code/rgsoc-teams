class ActivitiesPopulateMailingsContent < ActiveRecord::Migration
  def up
    Activity.where(kind: 'mailing').each do |activity|
      mailing = Mailing.find(activity.guid)
      activity.update_attributes!(content: mailing.body)
    end
  end
end
