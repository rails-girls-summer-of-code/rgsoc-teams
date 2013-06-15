class Team < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :members, class_name: 'User'
end