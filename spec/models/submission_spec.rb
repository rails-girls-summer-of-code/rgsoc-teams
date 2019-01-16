require 'rails_helper'

RSpec.describe Submission, type: :model do
  let(:submission) { build(:submission) }
  let(:unsent) { create(:submission, sent_at: nil) }

  describe '#sent?' do
    it 'lists unsent submissions' do
      expect(Submission.unsent).to include(unsent)
      expect(Submission.unsent).not_to include(submission)
    end
  end

  describe '#enqueue' do
    it 'submission is lined up for delivery' do
      ActiveJob::Base.queue_adapter = :test
      expect {
        Submission.create
      }.to have_enqueued_job.on_queue('mailers')
    end
  end
end
