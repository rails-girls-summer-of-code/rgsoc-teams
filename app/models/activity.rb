class Activity < ActiveRecord::Base
  paginates_per 50

  belongs_to :team

  attr_accessible :team_id, :kind, :guid, :title, :content, :author, :source_url, :published_at

  class << self
    def ordered
      order('published_at DESC, id DESC')
    end
  end
end
