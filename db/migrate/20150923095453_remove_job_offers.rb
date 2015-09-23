class RemoveJobOffers < ActiveRecord::Migration
  def up
    drop_table :job_offers
  end

  def down
    create_table "job_offers", force: :cascade do |t|
      t.string   "title",         limit: 255
      t.text     "description"
      t.string   "url",           limit: 255
      t.string   "company_name",  limit: 255
      t.string   "contact_name",  limit: 255
      t.string   "contact_email", limit: 255
      t.string   "contact_phone", limit: 255
      t.string   "location",      limit: 255
      t.string   "duration",      limit: 255
      t.boolean  "paid"
      t.boolean  "rgsoc_only"
      t.text     "misc_info"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end

end
