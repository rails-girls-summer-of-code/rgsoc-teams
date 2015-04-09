class ConvertTextualApplicationFieldsToTextOnUsers < ActiveRecord::Migration
  def up
    change_column :users, :application_gender_identification, :text
    change_column :users, :application_learning_period,       :text
  end

  def down
    change_column :users, :application_gender_identification, :string
    change_column :users, :application_learning_period,       :string
  end
end
