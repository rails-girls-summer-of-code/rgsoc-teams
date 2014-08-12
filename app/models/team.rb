class Team < ActiveRecord::Base
  include ProfilesHelper, ColorHelper

  KINDS = %w(sponsored voluntary)

  validates :kind, presence: true, if: :selected_team?, unless: :access?
  validates :name, uniqueness: true, allow_blank: true
  validates :projects, presence: true, if: :selected_team?, unless: :access?

  # validate :must_have_members
  # validate :must_have_unique_students

  attr_accessor :checked
 # attr_accessible :is_selected


  has_many :roles, dependent: :destroy
  has_many :members, class_name: 'User', through: :roles, source: :user
  Role::ROLES.each do |role|
    has_many role.pluralize.to_sym, -> { where(roles: { name: role }) }, class_name: 'User', through: :roles, source: :user
  end
  has_many :sources, dependent: :destroy
  has_many :activities, dependent: :destroy
  has_one :last_activity, -> { order('id DESC') }, class_name: 'Activity'
  has_many :comments
  has_many :applications
  belongs_to :event

  accepts_nested_attributes_for :roles, :sources, allow_destroy: true

  before_create :set_number
  before_save :set_last_checked, if: :checked

  class << self
    def ordered(sort = {})
      order([sort[:order] || 'kind, name || projects', sort[:direction] || 'asc'].join(' '))
    end
  end

  def set_number
    self.number = Team.count + 1
  end

  def kind
    super || ''
  end

  def display_name
    chunks = [name]
    chunks << projects unless admin_team?
    chunks = chunks.select(&:present?)
    chunks[1] = "(#{chunks[1]})" if chunks[1]
    "Team #{chunks.join(' ')}"
  end

  def sponsored?
    kind == 'sponsored'
  end

  def admin_team?
    helpdesk_team? || organizers_team? || supervisors_team?
  end

  def helpdesk_team?
    name.to_s.downcase == 'helpdesk'
  end

  def organizers_team?
    name.to_s.downcase == 'organizers'
  end

  def supervisors_team?
    name.to_s.downcase == 'supervisors'
  end

  def students_location
    students.map(&:location).reject(&:blank?).uniq.to_sentence
  end

  def last_checked_by
    user_id = self[:last_checked_by]
    User.find(user_id) if user_id
  end

  private

  def set_last_checked
    self.last_checked_at = Time.now
    self.last_checked_by = checked.is_a?(String) ? checked.to_i : checked.id
  end

  def selected_team?
    is_selected
  end

  def current_user
    Thread.current = self.current_user
  end

  def access?
    User.current.admin?
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
