class AddLanguageLearningToUsers < ActiveRecord::Migration
  def change
    add_column :users, :application_language_learning_period, :text
  end
end
