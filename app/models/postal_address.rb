class PostalAddress < ApplicationRecord
  belongs_to :user

  validates_presence_of :street, :state, :zip
end
