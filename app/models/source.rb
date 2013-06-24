class Source < ActiveRecord::Base
  KINDS = %w(blog repository)

  belongs_to :team

  validates :url, presence: true
  validates :kind, presence: true

  # def name
  #   @name ||= url.split('/')[-2, 2].join('/')
  # end
end
