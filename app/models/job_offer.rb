class JobOffer < ActiveRecord::Base
  validates :company_name, :contact_email, :country, :description, :title, presence: true
end
