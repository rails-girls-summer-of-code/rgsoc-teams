class Team < ActiveRecord::Base
  validates :name, uniqueness: true, allow_blank: true
  # validate :must_have_members
  # validate :must_have_unique_students

  has_many :roles, dependent: :destroy
  has_many :members,  class_name: 'User', through: :roles, source: :user
  has_many :students, class_name: 'User', through: :roles, source: :user, conditions: { roles: { name: 'student' } }
  has_many :coaches,  class_name: 'User', through: :roles, source: :user, conditions: { roles: { name: 'coach'   } }
  has_many :mentors,  class_name: 'User', through: :roles, source: :user, conditions: { roles: { name: 'mentor'  } }

  has_many :repositories, dependent: :destroy
  has_many :activities, dependent: :destroy

  accepts_nested_attributes_for :roles, allow_destroy: true

  before_create :set_number

  def set_number
    self.number = Team.count + 1
  end

  def display_name
    "Team #{name.present? ? name : '?'}"
  end

  def must_have_unique_students
    students.each do |user|
      errors.add(:base, "#{user.github_handle} is already member of another team") if (user.teams - [self]).present?
    end
  end

  def must_have_members
    errors.add(:team, 'must have at least one member') if members_empty?
  end

  def members_empty?
    roles.empty? or roles.all? { |role| role.marked_for_destruction? }
  end
end
