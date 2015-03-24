class AddApplicationDraftAasmStateColumn < ActiveRecord::Migration
  def change
    add_column :application_drafts, :state, :text, :default => 'draft', :null => false
  end
end
