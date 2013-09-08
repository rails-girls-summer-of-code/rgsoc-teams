require 'spec_helper'

describe Mailing do
  let(:mailing) { Mailing.new(from: 'from@email.com', to: Role::ROLES,
    cc: 'cc@email.com', bcc: 'bcc@email.com', subject: 'subject', body: '# body') }

  it { should have_many(:submissions).dependent(:destroy) }

  describe '#sent?' do
    pending 'TODO'
  end

  describe '#submit' do
    it 'should deliver seperate emails to all recipients (incl. cc and bcc)' do
      role = create :coach_role
      mailing.save!
      expect{mailing.submit}.to change{Submission.count}.by(mailing.emails.count)
    end
  end

  describe '#recipients' do
    pending 'TODO'
  end
end
