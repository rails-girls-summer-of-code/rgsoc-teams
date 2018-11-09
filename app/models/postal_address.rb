# frozen_string_literal: true
class PostalAddress < ApplicationRecord
  belongs_to :user
  validates_presence_of :address_line_1, :city, :postal_code, :country

  def formatted
    "#{capitalize(address_line_1)} #{capitalize(address_line_2)} #{capitalize(city)}, #{state_or_province} #{postal_code} #{country}"
  end

  private

  def capitalize(string)
    string.split.map(&:capitalize).join(' ')
  end
end
