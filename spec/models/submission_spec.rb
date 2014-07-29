require 'spec_helper'
describe Submission do
  let(:submission) { FactoryGirl.create(:submission) }
  context 'valid' do
    it 'should not give an error' do
      expect(submission.errored?).to eql false
    end
  end

  context 'sent' do
    it 'should have been sent' do
      expect(Submission.unsent).not_to eql nil
    end
  end
end