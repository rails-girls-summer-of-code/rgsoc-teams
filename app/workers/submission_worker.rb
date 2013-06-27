class SubmissionWorker
  include SuckerPunch::Worker

  def run(payload)
    puts "dequeued submission: #{payload}"
    ActiveRecord::Base.connection_pool.with_connection do
      submit(Submission.find(payload[:submission_id]))
    end
  end

  def submit(submission)
    puts "about to deliver to: #{submission.to}"
    Mailer.email(submission).deliver
    puts "done delivering to: #{submission.to}"
  rescue => e
    submission.error = e.message
  ensure
    submission.sent_at = Time.now
    submission.save!
  end
end
