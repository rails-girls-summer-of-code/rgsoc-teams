class Comment < ActiveRecord::Base
  belongs_to :team
  belongs_to :user

  class << self
    def ordered
      order('created_at DESC, id DESC')
    end
  end
end

