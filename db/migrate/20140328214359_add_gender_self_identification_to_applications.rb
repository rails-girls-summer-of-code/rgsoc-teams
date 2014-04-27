class AddGenderSelfIdentificationToApplications < ActiveRecord::Migration
  def change
    add_column :applications, :gender_identification_student, :string
    add_column :applications, :gender_identification_pair, :string
  end
end
