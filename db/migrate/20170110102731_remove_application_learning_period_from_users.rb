class RemoveApplicationLearningPeriodFromUsers < ActiveRecord::Migration[5.0]
  def change
    remove_column :users, :application_learning_period, :text
  end
end
