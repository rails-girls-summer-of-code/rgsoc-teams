class Note < ActiveRecord::Base

  def initialize(user)
   @user = user
  end

end
