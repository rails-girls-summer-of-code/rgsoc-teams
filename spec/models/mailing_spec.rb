require 'spec_helper'

describe Mailing do
  let(:mailing) { Mailing.new(
    from: Mailing::FROM,
    to: 'coaches',
    cc: 'cc@email.com',
    bcc: 'bcc@email.com',
    subject: 'subject',
    body: '# body'
  ) }

  it { is_expected.to validate_presence_of(:to) }
  it { is_expected.to validate_presence_of(:subject) }
  it { is_expected.to have_many(:submissions).dependent(:destroy) }

  describe '#sent?' do

    it 'returns false before submitting' do
      expect(mailing.subject).to eq 'subject'
      expect(subject.sent?).to eq false
    end

    it 'returns true after submitting' do
      mailing.save!
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

    it 'has a default sender' do
      expect(mailing.from).not_to be_nil
    end
  end

  describe '#recipient?' do
    let(:student) { FactoryBot.create(:student) }

    it 'returns false for a an empty recipients list' do
      subject.to = nil
      expect(subject.recipient? student).to be_falsey
    end

    it 'returns true if user has appropriate role' do
      subject.to = %w(students)
      expect(subject.recipient? student).to be_truthy
    end
  end
end
