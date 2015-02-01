require 'spec_helper'

describe SubmissionWorker do
  let(:submission) { FactoryGirl.create(:submission) }

  before do
    allow(Mailer).to receive(:email).and_return(Mailer)
    allow(Mailer).to receive(:deliver).and_return(true)
    allow_any_instance_of(Submission).to receive(:enqueue).and_return(true)
  end

  describe '.perform' do
    it 'calls submit with submission' do
      expect_any_instance_of(SubmissionWorker).to receive(:submit).with(submission)
      subject.perform(submission_id: submission.id)
    end
  end

  describe '.submit' do
    it 'sends via Mailer' do
      expect(Mailer).to receive(:email).and_return(Mailer)
      subject.submit(submission)
    end

    it 'logs an error to the submission' do
      allow(Mailer).to receive(:email).and_raise("Error")
      expect {
        subject.submit(submission)
      }.to change(submission, :error)
    end

    it 'ensures and sets a sent_time' do
      expect {
        subject.submit(submission)
      }.to change(submission, :sent_at)
    end
  end
end
