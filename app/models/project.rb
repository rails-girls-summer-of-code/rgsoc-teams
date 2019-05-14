# frozen_string_literal: true

class Project < ApplicationRecord
  include HasSeason
  include AASM

  belongs_to :submitter, class_name: 'User'
  has_many :maintainerships, dependent: :nullify
  has_many :maintainers, through: :maintainerships, source: :user
  has_many :comments, -> { order('created_at DESC') }, as: :commentable, dependent: :destroy

  has_many :first_choice_application_drafts,  class_name: 'ApplicationDraft', foreign_key: 'project1_id'
  has_many :second_choice_application_drafts, class_name: 'ApplicationDraft', foreign_key: 'project2_id'
  has_many :assigned_teams, class_name: 'Team' # working on the project; after application procedure

  validates :name, :submitter, :mentor_email, presence: true

  scope :not_rejected, -> { where.not(aasm_state: 'rejected') }
  scope :in_current_season, -> { where(season: Season.transition? ? Season.succ : Season.current) }

  before_validation :sanitize_url
  after_create :add_submitter_to_maintainers_list

  aasm whiny_transitions: false do
    state :proposed, initial: true
    state :accepted
    state :rejected
    state :pending

    event :start_review do
      transitions from: :proposed, to: :pending
    end

    event :accept do
      transitions from: :pending, to: :accepted
    end

    event :reject do
      transitions from: :pending, to: :rejected, after: -> { self.comments_locked = true }
    end
  end

  # Returns the accepted projects that ended up being assigned a team.
  #
  # @param season [Season] the season to query, defaults to the current one.
  def self.selected(season: Season.current)
    in_season(season).accepted.where(id: Team.in_season(season).accepted.pluck(:project_id))
  end

  def taglist
    tags.join(', ')
  end

  def taglist=(taglist)
    self.tags = taglist.split(',').map(&:strip).reject(&:blank?)
  end

  def to_param
    "#{id}-#{name}".parameterize
  end

  def subscribers
    [submitter, mentor, comments.map(&:user)].flatten.uniq
  end

  # FIXME Remove me after https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues/342
  class NullMentor
    attr_reader :email, :github_handle
    def initialize(project)
      @email = project.mentor_email.to_s.downcase
      @github_handle = project.mentor_github_handle.to_s.downcase
    end

    def eql?(user)
      user.github_handle.to_s.downcase == github_handle
    end
  end

  def mentor
    @mentor ||= begin
                  _mentor = NullMentor.new(self)
                  if _mentor.eql? submitter
                    submitter
                  else
                    _mentor
                  end
                end
  end

  private

  def sanitize_url
    self.url = "http://#{url}" unless url =~ %r{\Ahttp[s]?://}
  end

  def add_submitter_to_maintainers_list
    maintainers << submitter
  end
end
