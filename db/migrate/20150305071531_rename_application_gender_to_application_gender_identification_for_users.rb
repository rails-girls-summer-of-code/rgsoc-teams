class RenameApplicationGenderToApplicationGenderIdentificationForUsers < ActiveRecord::Migration
  def change
    rename_column :users, :application_gender, :application_gender_identification
  end
end
