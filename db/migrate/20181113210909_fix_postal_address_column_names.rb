class FixPostalAddressColumnNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :postal_addresses, :address_line_1, :line1
    rename_column :postal_addresses, :address_line_2, :line2
    rename_column :postal_addresses, :state_or_province, :state
    rename_column :postal_addresses, :postal_code, :zip
  end
end
