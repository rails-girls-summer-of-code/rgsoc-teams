class AddConfirmationTokenToRoles < ActiveRecord::Migration
  def change
    add_column :roles, :confirmation_token, :string
  end
end
