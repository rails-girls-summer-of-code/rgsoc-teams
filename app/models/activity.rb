class Activity < ActiveRecord::Base
  belongs_to :team

  attr_accessible :team_id, :kind, :guid, :title, :content, :author, :source_url, :published_at
end
