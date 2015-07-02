class Source < ActiveRecord::Base
  include UrlHelper

  KINDS = %w(blog repository)

  belongs_to :team

  validates :url, presence: true
  validates :kind, presence: true

  scope :for_accepted_teams, ->() { joins(:team).where("teams.kind" => %w(sponsored voluntary)) }

  def url=(url)
    super(normalize_url(url))
  end

  # def name
  #   @name ||= url.split('/')[-2, 2].join('/')
  # end
end
