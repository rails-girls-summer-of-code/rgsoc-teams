require 'spec_helper'

describe Recipients do
  let(:mailing) { build :mailing, cc: 'cc@email.com', bcc: 'bcc@email.com' }
  let(:recipients) { Recipients.new mailing }

  subject { described_class.new mailing }

  describe '#emails' do
    it 'collects all email addresses' do
      user_email = Faker::Internet.email
      allow(recipients).to receive_messages user_emails: [user_email]
      expect(recipients.emails).to eq([mailing.cc, mailing.bcc, user_email])
    end
  end

  describe '#roles' do
    it 'expands special "teams" role' do
      allow(mailing).to receive_messages(to: %w(teams))
      expect(subject.roles).to eql %w(student coach mentor)
    end

    it 'returns a list of singularized to elements' do
      groups = %w(students coaches organizers supervisors developers)
      allow(mailing).to receive_messages(to: groups)
      expect(subject.roles).to eql groups.map(&:singularize)
    end
  end

  describe '#user_emails' do
    let(:user) { mock_model('User', email: 'rgsoc@example.com') }

    it 'returns a list of emails when names are not present' do
      allow(subject).to receive_messages(users: [user])
      expect(subject.user_emails).to eql [user.email]
    end

    it 'returns a list formatted recipients when names are present' do
      allow(user).to receive_messages(name: 'Pocahontas')
      allow(subject).to receive_messages(users: [user])
      expect(subject.user_emails).to eql ["Pocahontas <#{user.email}>"]
    end
  end

  describe '#users' do
    let(:coach) { FactoryGirl.create(:coach) }
    let(:student) { FactoryGirl.create(:student) }

    it 'only returns user that matches role' do
      allow(mailing).to receive_messages(to: %w(students))
      expect(subject.users).to include student
      expect(subject.users).not_to include coach
    end
  end
end
