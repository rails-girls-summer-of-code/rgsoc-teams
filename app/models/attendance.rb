class Attendance < ActiveRecord::Base
  include GithubHandle

  belongs_to :team
  belongs_to :conference
end
