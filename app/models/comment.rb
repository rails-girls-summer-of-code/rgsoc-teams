class Comment < ActiveRecord::Base
  belongs_to :team
  belongs_to :user
  belongs_to :application
  belongs_to :project

  scope :recent, -> { order('created_at DESC').limit(3) }

  before_save :set_checked
  after_commit :notify!

  def for_application?
    !application_id.blank?
  end

  class << self
    def ordered
      order('created_at DESC, id DESC')
    end
  end

  def commentable
    [team, application, project].find(&:present?)
  end

  private

  def notify!
    case commentable
    when Project
      ProjectMailer.comment(project, self).deliver_later
    end
  end

  def set_checked
    return unless team
    team.checked = user
    team.save
  end
end
