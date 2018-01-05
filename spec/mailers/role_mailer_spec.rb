require "rails_helper"

RSpec.describe RoleMailer, type: :mailer do
  describe 'user_added_to_team' do
    let(:user) { create(:user) }
    let(:team) { create(:team) }
    let(:role) { create(:mentor_role, user: user, team: team) }

    before do
      subject
    end

    subject do
      described_class.user_added_to_team(role)
    end

    it 'has ENV["EMAIL_FROM"] as from' do
      expect(subject.from).to include(ENV['EMAIL_FROM'])
    end

    it 'has a the users email as to' do
      expect(subject.to).to include(user.email)
    end

    it 'sets the subject' do
      expect(subject.subject).to eq("[rgsoc-teams] You have been added to the #{team.name} team.")
    end
  end
end
