class User < ActiveRecord::Base
  include Authentication::ActiveRecordHelpers

  devise :registerable, :rememberable, :omniauthable

  attr_accessible :avatar_url, :name, :email, :homepage, :location, :bio
end
