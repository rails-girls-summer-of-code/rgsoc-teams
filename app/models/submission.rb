# frozen_string_literal: true

class Submission < ApplicationRecord
  belongs_to :mailing, optional: true

  after_commit :enqueue, on: :create

  scope :unsent, -> { where(sent_at: nil) }

  def enqueue
    Rails.logger.info "Enqueueing submission: #{id}"
    Mailer.email(self).deliver_later
  end

  def errored?
    error.present?
  end
end
