class AddCompanyFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_company, :boolean, default: false
    add_column :users, :company_name, :string
    add_column :users, :company_info, :text
  end
end
