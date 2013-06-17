class Team < ActiveRecord::Base
  validates :name, uniqueness: true

  has_many :roles
  has_many :members,  class_name: 'User', through: :roles, source: :member
  has_many :students, class_name: 'User', through: :roles, source: :member, conditions: { roles: { name: 'student' } }
  has_many :coaches,  class_name: 'User', through: :roles, source: :member, conditions: { roles: { name: 'coach'   } }
  has_many :mentors,  class_name: 'User', through: :roles, source: :member, conditions: { roles: { name: 'mentor'  } }

  has_many :repositories
  has_many :activities

  before_create :set_number

  def set_number
    self.number = Team.count + 1
  end

  def display_name
    "Team ##{number}".tap do |result|
      result << " #{name}" if name
      result << ", #{students.map(&:name_or_handle).join('/')}" if students.any?
    end
  end
end
