class PostalAddress < ApplicationRecord
  belongs_to :user
  validates_presence_of :address_line_1, :city, :postal_code, :country

  def formatted
    "#{address_line_1.split.map(&:capitalize).join(' ')} #{address_line_2} #{city}, #{state_or_province} #{postal_code} #{country}"
  end
end
