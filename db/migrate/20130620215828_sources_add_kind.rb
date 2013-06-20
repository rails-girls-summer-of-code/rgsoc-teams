class SourcesAddKind < ActiveRecord::Migration
  def change
    add_column :sources, :kind, :string
  end
end
