class ChangeDataTypeForGid < ActiveRecord::Migration[5.1]
  def self.up
    change_table :conferences do |t|
      t.change :gid, :string
    end
  end

  def self.down
    change_table :conferences do |t|
      t.change :gid, :integer
    end
  end
end
