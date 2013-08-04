class Activity < ActiveRecord::Base
  paginates_per 50

  belongs_to :team

  class << self
    def ordered
      order('published_at DESC, id DESC')
    end
  end

  def img_url
    super || '/assets/screenshot-missing.png'
  end
end
