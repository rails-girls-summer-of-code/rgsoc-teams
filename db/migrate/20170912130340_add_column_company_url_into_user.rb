class AddColumnCompanyUrlIntoUser < ActiveRecord::Migration[5.1]
  def up
    add_column :users, :company_url, :string
  end

  def down
    remove_column :users, :company_url
  end
end
