class Comment < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :application

  before_save :set_checked

  def for_application?
    !application_id.blank?
  end

  class << self
    def ordered
      order('created_at DESC, id DESC')
    end
  end

  private

  def set_checked
    self.team.checked = user if self.team
  end
end
