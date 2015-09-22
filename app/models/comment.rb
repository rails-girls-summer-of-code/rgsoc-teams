class Comment < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :application

  scope :recent, -> { order('created_at DESC').limit(3) }
  scope :latest, -> { order('created_at DESC').limit(1) }

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
    return unless team
    team.checked = user
    team.save
  end
end