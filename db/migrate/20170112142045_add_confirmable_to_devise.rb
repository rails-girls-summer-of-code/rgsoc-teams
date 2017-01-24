class AddConfirmableToDevise < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :confirmation_token, :string
    add_column :users, :confirmed_at, :datetime
    add_column :users, :confirmation_sent_at, :datetime
    add_index  :users, :confirmation_token, unique: true
    add_column :users, :unconfirmed_email, :string
    execute("UPDATE users SET confirmed_at = NOW()")
  end

  def down
    remove_columns :users, :confirmation_token, :confirmed_at,
      :confirmation_sent_at, :unconfirmed_email
  end
end
