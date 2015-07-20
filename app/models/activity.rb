class Activity < ActiveRecord::Base
  KINDS = %w(feed_entry mailing status_update)

  belongs_to :team

  validates :content, :title, :team, presence: { if: ->(act) { act.kind == 'status_update' } }

  delegate :students, to: :team

  class << self
    def with_kind(kind)
      where(kind: kind)
    end

    def by_team(team_id)
      where(team_id: team_id)
    end

    def ordered
      order('published_at DESC, id DESC')
    end
  end

  def to_param
    "#{id}-#{title.to_s.parameterize}"
  end
end
