require 'spec_helper'

describe Mailing do
  let(:mailing) { Mailing.new(
    from: 'from@email.com',
    to: 'coaches',
    cc: 'cc@email.com',
    bcc: 'bcc@email.com',
    subject: 'subject',
    body: '# body'
  ) }

  it { is_expected.to have_many(:submissions).dependent(:destroy) }

  describe '#sent?' do

    it 'returns false before submitting' do
      expect(mailing.subject).to eq 'subject'
      expect(subject.sent?).to eq false
    end

    it 'returns true after submitting' do
      mailing.save! # I need to save the parent (mailing) before I can submit (mailing.submit fires submission.create).
      mailing.submit
      expect(mailing.sent_at).not_to be_nil
      expect(mailing.submissions).not_to be_nil
      expect(mailing.sent?).to eq true
    end
  end

  describe '#submit' do
    it 'delivers emails to all recipients' do
      expect(mailing.recipients.emails).to eq(["cc@email.com", "bcc@email.com"])
      expect(mailing.recipients.to).to eq "coaches"
    end
  end

  describe '#recipient?' do
    let(:student) { FactoryGirl.create(:student) }

    it 'returns false for a an empty recipients list' do
      expect(subject.recipient? student).to be_falsey
    end

    it 'returns true if user has appropriate role' do
      subject.to = %w(students)
      expect(subject.recipient? student).to be_truthy
    end
  end
end
