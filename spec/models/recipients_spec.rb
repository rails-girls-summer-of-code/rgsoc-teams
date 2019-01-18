require 'rails_helper'

RSpec.describe Recipients, type: :model do
  let(:mailing) do
    build :mailing,
          cc: 'cc@email.com',
          bcc: 'bcc@email.com',
          to: to,
          group: group,
          seasons: seasons
  end
  let(:to) { %w(students) }
  let(:group) { 'everyone' }
  let(:seasons) { [] }
  let(:recipients) { Recipients.new mailing }

  subject { described_class.new mailing }

  describe '#emails' do
    it 'collects all email addresses' do
      user_email = FFaker::Internet.email
      allow(recipients).to receive_messages user_emails: [user_email]
      expect(recipients.emails).to eq([mailing.cc, mailing.bcc, user_email])
    end

    it 'returns unique email addresses' do
      cc  = FFaker::Internet.email
      bcc = FFaker::Internet.email
      user_emails = [cc.upcase, bcc, FFaker::Internet.email]

      allow(subject).to receive(:cc).and_return  [cc]
      allow(subject).to receive(:bcc).and_return [bcc]
      allow(subject).to receive(:user_emails).and_return user_emails

      expect(subject.emails).to match_array [cc, bcc, user_emails.last]
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

    it 'returns a list of emails' do
      allow(subject).to receive_messages(users: [user])
      expect(subject.user_emails).to eql [user.email]
    end
  end

  describe '#users' do
    context 'when grouped' do
      let(:to) { %w(students) }
      let!(:selected_team) { create(:team, kind: Team::KINDS.sample) }
      let!(:selected_students) { create_list(:student, 2, team: selected_team) }

      let!(:unselected_team) { create(:team, kind: nil) }
      let!(:unselected_students) { create_list(:student, 2, team: unselected_team) }

      context 'when group is selected_teams' do
        let(:group) { 'selected_teams' }

        it 'only returns students that belong to a selected team' do
          expect(subject.users).to match_array(selected_students)
        end
      end

      context 'when group is unselected_teams' do
        let(:group) { 'unselected_teams' }

        it 'only returns students that belong to an unselected team' do
          expect(subject.users).to match_array(unselected_students)
        end
      end

      context 'when group is everyone' do
        let(:group) { 'everyone' }

        it 'returns students that belong to either selected or unselected teams' do
          expect(subject.users).to match_array(selected_students + unselected_students)
        end
      end

      context 'when to is just organizers' do
        let(:to) { %w(organizers) }
        let!(:helpdesks) { create_list(:helpdesk, 2) }
        let!(:organizers) { create_list(:organizer, 2) }

        it 'returns all organizers' do
          expect(subject.users).to match_array(organizers)
        end
      end
    end

    context 'when seasons are selected' do
      let(:to) { %w(students) }
      let(:seasons) { %w(2015) }
      let(:season_2015) { create(:season, name: '2015') }
      let(:team) { create(:team, season: season_2015) }
      let!(:students) { create_list(:student, 2, team: team) }
      let!(:coaches) { create_list(:coach, 2, team: team) }
      let!(:other_students) { create_list(:student, 2) }
      let!(:organizers) { create_list(:organizer, 2) }

      it 'only returns students that belong to the 2015 season' do
        expect(subject.users).to match_array(students)
      end

      context 'when to includes organizers and students' do
        let(:to) { %w(students organizers developers helpdesk) }

        it 'returns students and organizers' do
          expect(subject.users).to match_array(students + organizers)
        end
      end
    end
  end
end
