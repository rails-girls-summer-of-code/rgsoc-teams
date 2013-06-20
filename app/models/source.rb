class Source < ActiveRecord::Base
  belongs_to :team

  validates :url, presence: true, uniqueness: true

  def name
    @name ||= url.split('/')[-2, 2].join('/')
  end
end
