class CreateConferencePreferenceInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :conference_preference_infos do |t|
      t.boolean :condition_term_ticket, default: false
      t.boolean :condition_term_cost, default: false
      t.boolean :lightning_talk, default: false
      t.text :comment
      t.references :team, foreign_key: true

      t.timestamps
    end
  end
end
