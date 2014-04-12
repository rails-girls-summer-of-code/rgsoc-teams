class Company < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true
  validates :owner_id, presence: true, uniqueness: true
  validates :website, uniqueness: true, allow_nil: true

  belongs_to :owner, class_name: 'User'
end
