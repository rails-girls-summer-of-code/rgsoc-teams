class Submission < ApplicationRecord
  class << self
    def unsent
      where(sent_at: nil)
    end
  end

  belongs_to :mailing

  after_commit :enqueue, on: :create

  def enqueue
    Rails.logger.info "Enqueueing submission: #{id}"
    Mailer.email(self).deliver_later
  end

  def errored?
    error.present?
  end
end
