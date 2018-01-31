# frozen_string_literal: true
class Source < ApplicationRecord
  include UrlHelper

  KINDS = %w(page repository blog)

  belongs_to :team

  validates :url, presence: true
  validates :kind, presence: true

  scope :for_accepted_teams, ->() { joins(:team).where("teams.kind" => %w(sponsored deprecated_voluntary)) }

  def url=(url)
    super(normalize_url(url))
  end

  # def name
  #   @name ||= url.split('/')[-2, 2].join('/')
  # end
end
