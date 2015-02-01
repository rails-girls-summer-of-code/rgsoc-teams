class AddApplicationInfoToUsers < ActiveRecord::Migration
  def change
    change_table :users do |t|
      t.boolean :application_voluntary
      t.integer :application_coding_level
      t.string :application_gender
      t.string :application_learning_period
      t.string :application_minimum_money
      t.text :application_about
      t.text :application_code_samples
      t.text :application_community_engagement
      t.text :application_learning_history
      t.text :application_location
      t.text :application_skills
    end
  end
end
