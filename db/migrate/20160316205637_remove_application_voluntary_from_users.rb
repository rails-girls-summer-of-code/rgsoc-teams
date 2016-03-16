class RemoveApplicationVoluntaryFromUsers < ActiveRecord::Migration
  def change
    remove_column :users, :application_voluntary, :boolean
  end
end
