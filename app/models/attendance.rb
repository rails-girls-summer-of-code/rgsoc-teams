class Attendance < ActiveRecord::Base
  include GithubHandle

  belongs_to :team, inverse_of: :attendances
  belongs_to :conference, inverse_of: :attendances
end
