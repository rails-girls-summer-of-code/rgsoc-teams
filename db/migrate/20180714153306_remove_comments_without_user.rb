class RemoveCommentsWithoutUser < ActiveRecord::Migration[5.1]
  def up
    execute <<~SQL
      DELETE
      FROM comments
      WHERE user_id NOT IN (SELECT id FROM users)
    SQL
  end
end
