class Activity < ActiveRecord::Base
  KINDS = %w(feed_entry mailing status_update)

  paginates_per 50

  belongs_to :team

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
end
