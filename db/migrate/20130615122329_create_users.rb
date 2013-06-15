class CreateUsers < ActiveRecord::Migration
  def change
    create_table(:users) do |t|
      t.integer :github_id
      t.string  :github_handle

      t.string  :name
      t.string  :email
      t.string  :location
      t.text    :bio
      t.string  :homepage
      t.string  :avatar_url

      t.timestamps
    end
  end
end
