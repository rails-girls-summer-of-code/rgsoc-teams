# frozen_string_literal: true
class PostalAddress < ApplicationRecord
  belongs_to :user

  validates_presence_of :street, :state, :zip

  def formatted_address
    street + " " + state + ", " + zip
  end
end
