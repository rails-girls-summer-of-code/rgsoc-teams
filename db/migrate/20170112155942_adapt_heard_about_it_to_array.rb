class AdaptHeardAboutItToArray < ActiveRecord::Migration[5.0]
  def change
    add_column :application_drafts, :heard_about_it_new, :string, array: true, default: []

    ApplicationDraft.all.each do |draft|
      draft.heard_about_it_new = [draft.heard_about_it]
      draft.save!
    end

    remove_column :application_drafts, :heard_about_it
    rename_column :application_drafts, :heard_about_it_new, :heard_about_it
  end
end
