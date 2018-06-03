class IndexTeamsOnKind < ActiveRecord::Migration[5.1]
  def change
    add_index :teams, :kind
  end
end
