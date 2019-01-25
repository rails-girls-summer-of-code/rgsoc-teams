# frozen_string_literal: true

module HasSeason
  extend ActiveSupport::Concern

  included do
    belongs_to :season, optional: true

    # @param season [#name, String, Integer]
    # @return [ActiveRecord::Relation]
    def self.in_season(season)
      season = season.try(:name) || season
      joins(:season).where('seasons.name' => season)
    end
  end
end
