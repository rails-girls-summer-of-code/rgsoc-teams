class Attendance < ActiveRecord::Base
  include GithubHandle

  belongs_to :team, inverse_of: :attendances
  belongs_to :conference, inverse_of: :attendances

  validates_uniqueness_of :conference, scope: [:team_id]
end
