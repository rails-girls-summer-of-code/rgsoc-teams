class SourcesAddTitle < ActiveRecord::Migration
  def change
    add_column :sources, :title, :string
  end
end
