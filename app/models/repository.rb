class Repository < ActiveRecord::Base
  belongs_to :team

  validates :url, presence: true, uniqueness: true
end
