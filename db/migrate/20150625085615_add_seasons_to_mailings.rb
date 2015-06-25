class AddSeasonsToMailings < ActiveRecord::Migration
  def change
    add_column :mailings, :seasons, :text, array: true, default: []
    Mailing.update_all(seasons: [Season.current.name])
  end
end
