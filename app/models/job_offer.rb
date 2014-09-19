class JobOffer < ActiveRecord::Base
  validates :company_name, :contact_email, :description, :location, :title, presence: true
end
