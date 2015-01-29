class Project < ActiveRecord::Base
  belongs_to :team

  validates :name, presence: true
end
