class DestroyOrphanedActivities < ActiveRecord::Migration[5.1]
  def up
    execute 'DELETE FROM activities WHERE team_id IS NULL'
  end
end
