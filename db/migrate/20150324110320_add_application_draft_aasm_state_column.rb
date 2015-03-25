class AddApplicationDraftAasmStateColumn < ActiveRecord::Migration
  def change
    add_column :application_drafts, :aasm_state, :text, :default => 'draft', :null => false
  end
end
