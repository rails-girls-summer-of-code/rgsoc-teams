class TeamsAddPostInfo < ActiveRecord::Migration
  def change
    add_column :teams, :post_info, :string
  end
end
