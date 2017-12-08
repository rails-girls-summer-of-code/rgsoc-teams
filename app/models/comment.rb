# frozen_string_literal: true
class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :project
  belongs_to :commentable, polymorphic: true

  scope :recent, -> { order('created_at DESC').limit(3) }

  before_save :set_checked
  after_commit :notify!

  def for_application?
    commentable.is_a? Application
  end

  class << self
    def ordered
      order('created_at DESC, id DESC')
    end
  end

  private

  def notify!
    case commentable
    when Project
      ProjectMailer.comment(project, self).deliver_later
    end
  end

  def set_checked
    return unless commentable.is_a? Team
    commentable.checked = user
    commentable.save
  end
end
