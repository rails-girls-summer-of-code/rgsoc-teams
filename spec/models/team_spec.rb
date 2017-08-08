require 'spec_helper'

describe Team do
  subject { Team.new(kind: 'sponsored') }

  it { is_expected.to have_many(:activities) }
  it { is_expected.to have_many(:sources) }
  it { is_expected.to have_many(:members) }
  it { is_expected.to have_many(:students) }
  it { is_expected.to have_many(:coaches) }
  it { is_expected.to have_many(:mentors) }
  it { is_expected.to have_many(:helpdesks) }
  it { is_expected.to have_many(:organizers) }
  it { is_expected.to have_many(:supervisors) }
  it { is_expected.to have_many(:status_updates) }
  it { is_expected.to have_many(:roles).inverse_of(:team) }
  it { expect(subject).to have_one(:conference_preference).dependent(:destroy) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_uniqueness_of(:name) }

  context 'multiple team memberships' do
    let!(:existing_team) { role.team }
    let(:role)   { FactoryGirl.create "#{role_name}_role" }
    let(:member) { role.user }
    let(:user) { create(:user) }
    let(:team) { create :team, :in_current_season }
    let(:roles_attributes) { [{ name: role_name, team_id: team.id, user_id: member.id }] }

    context 'for students' do
      let(:role_name) { 'student' }

      it 'allows no more than one team as a student' do
        team.attributes = { roles_attributes: roles_attributes }
        expect { team.save team.season }.not_to change { team.members.count }
        expect(team.errors[:base].first).to eql "#{member.name} already is a student on another team for #{Season.current.name}."
      end

      context 'spanning multiple seasons' do
        let(:past_season) { Season.create name: 2000 }
        let(:old_team)    { create :team, season: past_season }
        let(:member)      { past_role.user }
        let!(:past_role)  { create "#{role_name}_role", team: old_team }

        it 'allows adding a student who already is a student, but from another season' do
          team.attributes = { roles_attributes: roles_attributes }
          expect { team.save }.to change { team.members.count }.by(1)
        end
      end

      it 'allows adding a student who is not yet part of a team' do
        team.attributes = { roles_attributes: [{ name: role_name, user_id: user.id }] }
        expect { team.save }.to change { team.members.count }.by(1)
      end

      it 'allows updating a team' do
        expect {
          team.update roles_attributes: [{ name: role_name, user_id: user.id }]
        }.to change { team.members.count }.by(1)
      end
    end

    context 'as a non-student' do
      let(:role_name) { %w(coach mentor supervisor).sample }

      it 'allows multiple memberships' do
        team.attributes = { roles_attributes: roles_attributes }
        expect { team.save }.to change { team.members.count }.by(1)
      end
    end
  end

  describe 'limit of students' do
    let(:team) { create :team }
    let(:new_user) { create :user }
    let(:new_student) { -> {{ name: 'student', team_id: team.id, user_id: new_user.id }} }
    let(:new_student_as_coach) { -> {{ name: 'coach', team_id: team.id, user_id: new_user.id }} }
    let(:second_new_student) { -> {{ name: 'student', team_id: team.id, user_id: create(:user).id }} }
    let(:third_new_student) { -> {{ name: 'student', team_id: team.id, user_id: create(:user).id }} }
    let(:remove_student) { -> {{ name: 'student', team_id: team.id, user_id: create(:user).id, _destroy: true }} }

    context 'when team has no students yet' do
      it 'allows to add 2 new students' do
        roles_attributes = [new_student.call, second_new_student.call]
        expect {
          team.update roles_attributes: roles_attributes
        }.to change { team.members.count }.by 2
      end

      it 'ignores students marked for destruction' do
        roles_attributes = [new_student.call, second_new_student.call]
        roles_attributes << remove_student.call
        expect {
          team.update roles_attributes: roles_attributes
        }.to change { team.members.count }.by 2
      end

      it 'does not allow to add more than 2 new students' do
        roles_attributes = [new_student.call, second_new_student.call, third_new_student.call]
        team.attributes = { roles_attributes: roles_attributes }
        expect { team.save }.not_to change { team.members.count }
        expect(team.errors[:roles].first).to eql 'there cannot be more than 2 students on a team.'
      end

      it 'does not allow the same student to fill up both spots' do
        roles_attributes = [new_student.call] * 2
        team.attributes = { roles_attributes: roles_attributes }
        expect { team.save }.not_to change { team.members.count }
        expect(team.errors[:base].first).to eql "#{new_user.name} can't have more than one role in this team!"
      end

      it 'does not allow the same student to add themselves as a coach' do
        roles_attributes = [new_student.call, new_student_as_coach.call]
        team.attributes = { roles_attributes: roles_attributes }
        expect { team.save }.not_to change { team.members.count }
        expect(team.errors[:base].first).to eql "#{new_user.name} can't have more than one role in this team!"
      end
    end
    context 'when team has students' do
      let!(:student_1) { create :student_role, team: team, user: create(:user) }
      let!(:student_2) { create :student_role, team: team, user: create(:user) }
      before { team.reload }

      it 'does not allow to add new students' do
        roles_attributes = [new_student.call]
        team.attributes = { roles_attributes: roles_attributes }
        expect { team.save }.not_to change { team.members.count }
        expect(team.errors[:roles].first).to eql 'there cannot be more than 2 students on a team.'
      end

      it 'allows to remove existing student and add new' do
        roles_attributes = [{ id: student_1.id, _destroy: true }, new_student.call]
        expect {
          team.update roles_attributes: roles_attributes
        }.not_to change { team.students.count }
        expect(team.students).not_to include student_1
      end

      it 'allows to edit role of existing student and add new' do
        roles_attributes = [{ id: student_1.id, name: 'coach' }, new_student.call]
        expect {
          team.update roles_attributes: roles_attributes
        }.not_to change { team.students.count }
        expect(team.students).not_to include student_1
      end
    end
  end

  describe '#coaches_confirmed?' do
    let(:role)   { FactoryGirl.create "#{role_name}_role" }
    let(:role_name)   { 'coach' }
    let(:member) { role.user }
    let(:user) { create(:user) }
    let(:team) { FactoryGirl.create(:team) }
    let(:roles_attributes) { [{ name: role_name, team_id: team.id, user_id: member.id }] }

    it 'says its coaches are confirmed when all coaches are confirmed' do
      team.attributes = { roles_attributes: roles_attributes }
      team.roles.each { |role| role.confirm! unless role.confirmed? }
      team.save!
      expect(team).to be_coaches_confirmed
    end

    it 'says its coaches are not confirmed when not all coaches are confirmed' do
      team.attributes = { roles_attributes: roles_attributes }
      team.save!
      expect(team).to_not be_coaches_confirmed
    end
  end

  describe '#confirmed?' do
    let(:first_student) { create(:user) }
    let(:second_student) { create(:user) }
    let(:team) { FactoryGirl.create(:team) }
    let(:role_name) { 'student' }
    it 'will not be confirmed if only one student present' do
      team.attributes = { roles_attributes: [{ name: role_name, user_id: first_student.id }] }
      expect { team.save! }.not_to change { team.confirmed? }.from false
    end

    it 'will confirm team through role assignment when second student present' do
      team.attributes = { roles_attributes: [{ name: role_name, user_id: first_student.id }, { name: role_name, user_id: second_student.id }] }
      expect { team.save! }.to change { team.confirmed? }.to true
    end
  end


  it_behaves_like 'HasSeason'

  context 'with scopes' do
    let!(:team) { create :team, kind: nil }

    describe '.visible' do

      it 'returns teams that are not marked invisible' do
        expect(described_class.visible).to eq [team]
      end

      it 'will not return an invisible team' do
        team.update(invisible: true)
        expect(described_class.visible).to eq []
      end

      context 'with accepted teams' do
        let(:kind) { described_class::KINDS.sample }
        before { team.update kind: kind, invisible: true }

        it 'will always return accepted teams' do
          expect(described_class.visible).to eq [team]
        end
      end
    end

    describe '.without_recent_log_update' do
      let(:team_without) do
        create :team
      end

      let(:team_with_old) do
        team_with_old = create :team
        create :status_update, created_at: 2.days.ago, team: team_with_old
        team_with_old
      end

      let(:team_with_recent_status_update) do
        team_with_recent_status_update = create :team
        create :status_update, created_at: 1.hour.ago, team: team_with_recent_status_update
        team_with_recent_status_update
      end

      let(:team_with_recent_feed_entry) do
        team_with_recent_feed_entry = create :team
        create :activity, :feed_entry, created_at: 1.hour.ago, team: team_with_recent_feed_entry
        team_with_recent_feed_entry
      end

      it 'includes the team without any status updates' do
        team_without
        expect(described_class.without_recent_log_update).to include(team_without)
      end

      it 'includes the team with only old updates' do
        team_with_old
        expect(described_class.without_recent_log_update).to include(team_with_old)
      end

      it 'does not include the teams with recent updates' do
        team_with_recent_status_update
        team_with_recent_feed_entry
        expect(described_class.without_recent_log_update).not_to include(team_with_recent_status_update)
        expect(described_class.without_recent_log_update).not_to include(team_with_recent_feed_entry)

      end
    end

  end

  describe 'creating a new team' do
    before do
      Team.destroy_all
    end

    subject { create :team }

    it 'sets the team number' do
      expect(subject.reload.number).to eql 1
    end
  end

  describe '#display_name' do
    context 'with a project name' do
      before { subject.project_name = 'Sinatra' }

      it 'returns "Team Sinatra" if no name given' do
        expect(subject.display_name).to eql 'Team Sinatra'
      end

      it 'returns "Team Blue" if name given' do
        subject.name = 'Blue'
        expect(subject.display_name).to eql 'Team Blue (Sinatra)'
      end
    end

    context 'with season information' do
      subject { described_class.new season: season, name: 'Cheesy' }

      context 'for a current team' do
        let(:season) { Season.current }

        it 'will not display the year' do
          expect(subject.display_name).to eql 'Team Cheesy'
        end
      end

      context 'for a past team' do
        let(:season) { create :season, name: Date.today.year - 1 }

        it 'will append the year' do
          expect(subject.display_name).to eql "Team Cheesy [#{season.name}]"
        end
      end
    end

    it 'will not prepend "Team" if already in place' do
      subject.name = "Team Three Headed Monkey"
      expect(subject.display_name).to eql "Team Three Headed Monkey"
    end
  end

  describe '#github_handle=' do
    it 'keeps an empty handle' do
      expect(Team.new(github_handle: nil).github_handle).to be_nil
    end

    it 'strips leading/tailing spaces' do
      expect(Team.new(github_handle: ' foo ').github_handle).to be == 'foo'
    end

    it 'extracts the handle from a github url' do
      expect(Team.new(github_handle: 'https://github.com/foo').github_handle).to be == 'foo'
    end
  end

  describe '#twitter_handle=' do
    it 'keeps an empty handle' do
      expect(Team.new(twitter_handle: nil).twitter_handle).to be_nil
    end

    it 'with an @' do
      expect(Team.new(twitter_handle: '@foo').twitter_handle).to be == '@foo'
    end

    it 'strips leading/tailing spaces' do
      expect(Team.new(twitter_handle: ' foo ').twitter_handle).to be == '@foo'
    end

    it 'extracts the handle from a github url' do
      expect(Team.new(twitter_handle: 'https://twitter.com/foo').twitter_handle).to be == '@foo'
    end
  end

  describe 'checking' do
    let(:user) { FactoryGirl.create(:user) }

    subject { create :team }

    it 'changes last_checked_*' do
      expect {
        subject.checked = user
        subject.save!
      }.to change(subject, :last_checked_by) && change(subject, :last_checked_at)
    end
  end

  describe '#accepted?' do
    it 'returns false' do
      subject.kind = nil
      expect(subject).not_to be_accepted
    end

    it 'returns false for a voluntary team' do
      subject.kind = 'voluntary'
      expect(subject).to be_accepted
    end

    it 'returns true for a sponsored team' do
      subject.kind = 'sponsored'
      expect(subject).to be_accepted
    end
  end

  describe '#sponsored?' do
    it 'returns false' do
      subject.kind = 'voluntary'
      expect(subject).not_to be_sponsored
    end

    it 'returns true' do
      subject.kind = 'sponsored'
      expect(subject).to be_sponsored
    end
  end

  describe '#voluntary?' do
    it 'returns false' do
      subject.kind = nil
      expect(subject).not_to be_voluntary
    end

    it 'returns true' do
      subject.kind = 'voluntary'
      expect(subject).to be_voluntary
    end
  end

  describe 'accept nested attributes for all three models' do
    it { is_expected.to accept_nested_attributes_for :roles }
    it { is_expected.to accept_nested_attributes_for :sources }
  end

  describe '#application' do
    it 'returns the current season\'s application' do
      season1 = create :season, name: '2013'
      team = create :team
      create(:application, season: season1, team: team)
      application = create(:application, season: Season.current, team: team)
      expect(team.application).to eql application
    end
  end

end
