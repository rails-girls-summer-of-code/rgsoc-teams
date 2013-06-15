class Team < ActiveRecord::Base
  validates :name, presence: true, uniqueness: true

  has_many :members,  class_name: 'User'
  has_many :students, class_name: 'User', conditions: { role: 'student' }
  has_many :coaches,  class_name: 'User', conditions: { role: 'coach' }
  has_many :mentors,  class_name: 'User', conditions: { role: 'mentor' }

  has_many :repositories
end