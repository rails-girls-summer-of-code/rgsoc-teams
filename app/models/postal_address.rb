# frozen_string_literal: true
class PostalAddress < ApplicationRecord
  belongs_to :user

  validates_presence_of :line1, :city, :zip, :country
end
