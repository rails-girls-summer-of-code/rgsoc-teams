require 'spec_helper'

describe SubmissionWorker do
  let(:submission) { FactoryGirl.create(:submission) }

  before do
    Mailer.stub(:email).and_return(Mailer)
    Mailer.stub(:deliver).and_return(true)
    Submission.any_instance.stub(:enqueue).and_return(true)
  end

  describe '.perform' do
    it 'calls submit with submission' do
      SubmissionWorker.any_instance.should_receive(:submit).with(submission)
      subject.perform(submission_id: submission.id)
    end
  end

  describe '.submit' do
    it 'sends via Mailer' do
      Mailer.should_receive(:email).and_return(Mailer)
      subject.submit(submission)
    end

    it 'logs an error to the submission' do
      Mailer.stub(:email).and_raise("Error")
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
