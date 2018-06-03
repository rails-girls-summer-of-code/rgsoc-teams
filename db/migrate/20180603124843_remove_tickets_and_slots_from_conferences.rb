class RemoveTicketsAndSlotsFromConferences < ActiveRecord::Migration[5.1]
  def change
    remove_column :conferences, :tickets, :integer
    remove_column :conferences, :lightningtalkslots, :boolean
  end
end
