class Application < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user_id, :name, :email, :application_data
end
