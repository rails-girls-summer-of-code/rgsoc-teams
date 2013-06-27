class Submission < ActiveRecord::Base
  belongs_to :mailing

  after_commit :enqueue, on: :create

  def enqueue
    puts "enqueueing submission: #{id}"
    SuckerPunch::Queue[:submissions].async.run(submission_id: id)
  end
end

