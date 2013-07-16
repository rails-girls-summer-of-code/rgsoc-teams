class Team < ActiveRecord::Base
  include ProfilesHelper, ColorHelper

  KINDS = %w(sponsored voluntary)

  validates :kind, presence: true
  validates :name, uniqueness: true, allow_blank: true
  validates :projects, presence: true
  # validate :must_have_members
  # validate :must_have_unique_students

  has_many :roles, dependent: :destroy
  has_many :members, class_name: 'User', through: :roles, source: :user
  Role::ROLES.each do |role|
    has_many role.pluralize.to_sym, -> { where(roles: { name: role }) }, class_name: 'User', through: :roles, source: :user
  end
  has_many :sources, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_one :last_activity, -> { order('id DESC') }, class_name: 'Activity'

  accepts_nested_attributes_for :roles, :sources, allow_destroy: true

  before_create :set_number

  def set_number
    self.number = Team.count + 1
  end

  def kind
    super || ''
  end

  def display_name
    chunks = [name, projects].select(&:present?)
    chunks[1] = "(#{chunks[1]})" if chunks[1]
    "Team #{chunks.join(' ')}"
  end

  def helpdesk?
    name.downcase == 'helpdesk'
  end

  # def must_have_unique_students
  #   students.each do |user|
  #     errors.add(:base, "#{user.github_handle} is already member of another team") if (user.teams - [self]).present?
  #   end
  # end

  # def must_have_members
  #   errors.add(:team, 'must have at least one member') if members_empty?
  # end

  # def members_empty?
  #   roles.empty? or roles.all? { |role| role.marked_for_destruction? }
  # end
end
