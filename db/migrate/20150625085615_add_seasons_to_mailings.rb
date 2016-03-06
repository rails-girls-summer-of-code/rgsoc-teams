class AddSeasonsToMailings < ActiveRecord::Migration
  def change
    add_column :mailings, :seasons, :text, array: true, default: []
  end
end
