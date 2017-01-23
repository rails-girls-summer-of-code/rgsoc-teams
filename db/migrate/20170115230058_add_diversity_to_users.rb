class AddDiversityToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :application_diversity, :text
  end
end
