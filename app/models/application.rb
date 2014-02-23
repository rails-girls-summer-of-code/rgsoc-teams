class Application < ActiveRecord::Base
  validates_presence_of :name, :email, :application_data

end
