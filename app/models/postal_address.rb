# frozen_string_literal: true
class PostalAddress < ApplicationRecord
  belongs_to :user

  validates_presence_of :line1, :city, :zip, :country

  def formatted
    "#{line1.titlecase} #{line2.titlecase} #{city.titlecase}, #{state} #{zip} #{country}"
  end
end
