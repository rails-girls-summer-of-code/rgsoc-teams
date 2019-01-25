# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true

  scope :recent, -> { order('created_at DESC').limit(3) }
  scope :ordered, -> { order('created_at DESC, id DESC') }

  before_save :set_checked
  after_commit :notify!

  def for_application?
    commentable.is_a? Application
  end

  private

  def notify!
    return unless commentable.is_a?(Project)
    ProjectMailer.comment(commentable, self).deliver_later
  end

  def set_checked
    return unless commentable.is_a?(Team)
    commentable.update(checked: user)
  end
end
