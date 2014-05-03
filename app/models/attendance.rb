class Attendance < ActiveRecord::Base
  include GithubHandle

  belongs_to :user
  belongs_to :conference
end
