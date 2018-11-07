class PostalAddress < ApplicationRecord
  belongs_to :user
  validates_presence_of :address_line_1, :city, :postal_code, :country
end
