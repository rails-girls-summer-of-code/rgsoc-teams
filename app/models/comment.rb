class Comment < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :application

  def for_application?
    !application_id.blank?
  end

  class << self
    def ordered
      order('created_at DESC, id DESC')
    end
  end
end
