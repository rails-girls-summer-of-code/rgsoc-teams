# frozen_string_literal: true

class Source < ApplicationRecord
  include UrlHelper

  KINDS = %w(page repository blog)

  belongs_to :team, optional: true

  validates :url, presence: true
  validates :kind, presence: true

  scope :for_accepted_teams, -> { joins(:team).merge(Team.accepted) }

  def url=(url)
    super(normalize_url(url))
  end
end
