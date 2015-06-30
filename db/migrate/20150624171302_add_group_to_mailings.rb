class AddGroupToMailings < ActiveRecord::Migration
  def change
    add_column :mailings, :group, :integer, default: 0
  end
end
