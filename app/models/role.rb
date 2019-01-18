# frozen_string_literal: true

class Role < ApplicationRecord
  include AASM

  TEAM_ROLES  = %w(student coach)
  OTHER_ROLES = %w(helpdesk reviewer supervisor mentor)
  ADMIN_ROLES = %w(organizer developer)
  ROLES = TEAM_ROLES + OTHER_ROLES + ADMIN_ROLES

  GUIDE_ROLES = %w(coach mentor supervisor)
  FULL_TEAM_ROLES = TEAM_ROLES + GUIDE_ROLES
  CONTRIBUTOR_ROLES = ADMIN_ROLES + GUIDE_ROLES

  belongs_to :user
  belongs_to :team, optional: true

  delegate :github_handle, to: :user, allow_nil: true

  validates :user, presence: true
  validates :name, inclusion: { in: ROLES }, presence: true
  validates :user_id, uniqueness: { scope: [:name, :team_id] }

  before_create :set_confirmation_token
  after_commit :send_notification, on: :create

  after_create do |role|
    role.confirm! unless role.name == 'coach'
  end

  class << self
    def includes?(role_name)
      where(name: role_name).any?
    end
  end

  aasm column: :state, no_direct_assignment: true do
    state :pending, initial: true
    state :confirmed

    event :confirm do
      transitions from: :pending, to: :confirmed
    end
  end

  def github_handle=(github_handle)
    return unless github_handle.present?
    self.user = User.where('github_handle ILIKE ?', github_handle)
                    .first_or_initialize(github_handle: github_handle)
    user.github_import = true
  end

  private

  def send_notification
    RoleMailer.user_added_to_team(self).deliver_later
  end

  def set_confirmation_token
    self.confirmation_token = SecureRandom.hex(8)
  end
end
