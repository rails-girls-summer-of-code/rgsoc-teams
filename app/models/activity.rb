# frozen_string_literal: true

class Activity < ApplicationRecord
  KINDS = %w(feed_entry mailing status_update)

  belongs_to :team, optional: true
  has_many :comments, -> { ordered }, as: :commentable, dependent: :destroy

  validates :content, :title, :team, presence: { if: ->(act) { act.kind == 'status_update' } }

  delegate :students, to: :team

  scope :with_kind, ->(kind) { where(kind: kind) }
  scope :by_team, ->(team_id) { where(team_id: team_id) }
  scope :ordered, -> { order('published_at DESC, id DESC') }

  def to_param
    "#{id}-#{title.to_s.parameterize}"
  end
end
