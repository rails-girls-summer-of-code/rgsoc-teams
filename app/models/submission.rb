class Submission < ActiveRecord::Base
  class << self
    def unsent
      where(sent_at: nil)
    end
  end

  belongs_to :mailing

  after_commit :enqueue, on: :create

  def enqueue
    puts "enqueueing submission: #{id}"
    SuckerPunch::Queue[:submissions].async.run(submission_id: id)
  end

  def errored?
    error.present?
  end
end

