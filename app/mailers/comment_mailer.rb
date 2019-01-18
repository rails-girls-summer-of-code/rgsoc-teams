# frozen_string_literal: true

class CommentMailer < ActionMailer::Base
  include ActionView::Helpers::TextHelper

  default from: ENV['EMAIL_FROM'] || 'contact@rgsoc.org'

  attr_reader :team, :comment
  helper_method :team, :comment

  def email(comment)
    set comment
    mail subject: subject, to: 'contact@rgsoc.org'
  end

  private

  def subject
    "[rgsoc-teams] New comment: #{team.name} - #{truncate(comment.text)}"
  end

  def set(comment)
    @team = comment.commentable
    @comment = comment
  end
end
