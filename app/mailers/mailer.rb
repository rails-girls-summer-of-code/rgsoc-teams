class Mailer < ActionMailer::Base
  helper :markdown

  attr_reader :submission, :mailing

  delegate :subject, :body, :cc, :bcc, :from, to: :mailing
  delegate :to, to: :submission

  helper_method :subject, :body, :to, :cc, :bcc

  def email(submission)
    set submission
    mail subject: subject, from: from, to: to, cc: cc, bcc: bcc
  end

  private

    def set(submission)
      @submission = submission
      @mailing = submission.mailing
    end
end

