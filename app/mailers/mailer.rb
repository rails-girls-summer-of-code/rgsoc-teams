# frozen_string_literal: true

class Mailer < ActionMailer::Base
  helper :markdown

  attr_reader :submission, :mailing

  delegate :subject, :body, :cc, :bcc, :from, to: :mailing
  delegate :to, to: :submission

  helper_method :subject, :body, :to, :cc, :bcc

  def email(submission)
    set submission
    mail subject: subject, from: from, to: to
  rescue => e
    submission.error = e.message
  ensure
    submission.sent_at = Time.now.utc
    submission.save!
  end

  private

  def set(submission)
    @submission = submission
    @mailing = submission.mailing
  end
end
