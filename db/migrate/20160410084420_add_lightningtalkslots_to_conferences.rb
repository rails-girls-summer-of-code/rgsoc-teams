class AddLightningtalkslotsToConferences < ActiveRecord::Migration
  def change
    add_column :conferences, :lightningtalkslots, :boolean
  end
end
