class AddExplicitNullForTimestamps < ActiveRecord::Migration
  def change
    change_column_null :activities, :created_at, false
    change_column_null :activities, :updated_at, false

    change_column_null :attendances, :created_at, false
    change_column_null :attendances, :updated_at, false

    change_column_null :comments, :created_at, false
    change_column_null :comments, :updated_at, false

    change_column_null :conferences, :created_at, false
    change_column_null :conferences, :updated_at, false

    change_column_null :mailings, :created_at, false
    change_column_null :mailings, :updated_at, false

    change_column_null :roles, :created_at, false
    change_column_null :roles, :updated_at, false

    change_column_null :sources, :created_at, false
    change_column_null :sources, :updated_at, false

    change_column_null :submissions, :created_at, false
    change_column_null :submissions, :updated_at, false

    change_column_null :teams, :created_at, false
    change_column_null :teams, :updated_at, false

    change_column_null :users, :created_at, false
    change_column_null :users, :updated_at, false
  end
end
