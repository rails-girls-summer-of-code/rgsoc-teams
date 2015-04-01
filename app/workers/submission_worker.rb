class SubmissionWorker
  include SuckerPunch::Job

  def logger
    Rails.logger
  end

  def perform(payload)
    logger.info "dequeued submission: #{payload}"
    ActiveRecord::Base.connection_pool.with_connection do
      submit(Submission.find(payload[:submission_id]))
    end
  end

  def submit(submission)
    logger.info "about to deliver to: #{submission.to}"
    submission.error = nil
    Mailer.email(submission).deliver
    logger.info "done delivering to: #{submission.to}"
  rescue => e
    logger.info "[error] delivering to: #{submission.to}"
    logger.info e.message
    submission.error = e.message
  ensure
    submission.sent_at = Time.now
    submission.save!
  end
end
