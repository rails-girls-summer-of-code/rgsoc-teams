class CreateJobOffers < ActiveRecord::Migration
  def change
    create_table :job_offers do |t|
      t.string :title
      t.text :description
      t.string :url
      t.string :company_name
      t.string :contact_name
      t.string :contact_email
      t.string :contact_phone
      t.string :location
      t.string :duration
      t.boolean :paid
      t.boolean :rgsoc_only
      t.text :misc_info

      t.timestamps
    end
  end
end
