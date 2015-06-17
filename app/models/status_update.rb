class StatusUpdate < ActiveRecord::Base
  belongs_to :team

  validates :body, :subject, :team, presence: true
end
