class CreateRepositories < ActiveRecord::Migration
  def change
    create_table :repositories do |t|
      t.string :url
      t.references :team

      t.timestamps
    end
  end
end
