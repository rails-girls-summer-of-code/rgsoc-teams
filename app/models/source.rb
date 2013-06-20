class Source < ActiveRecord::Base
  KINDS = %w(repository log)

  belongs_to :team

  validates :url, presence: true, uniqueness: true
  validates :kind, presence: true

  # def name
  #   @name ||= url.split('/')[-2, 2].join('/')
  # end
end
