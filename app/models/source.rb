class Source < ActiveRecord::Base
  include UrlHelper

  KINDS = %w(blog repository)

  belongs_to :team

  # COMMENTING OUT VALIDATIONS BECAUSE NO ACCESS TO PROD DB
  #validates :url, presence: true
  #validates :kind, presence: true

  def url=(url)
    super(normalize_url(url))
  end

  # def name
  #   @name ||= url.split('/')[-2, 2].join('/')
  # end
end
