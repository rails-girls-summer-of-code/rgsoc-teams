class TeamsAddKind < ActiveRecord::Migration
  def change
    add_column :teams, :kind, :string
  end
end
