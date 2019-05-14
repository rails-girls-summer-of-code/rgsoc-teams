require 'rails_helper'

RSpec.describe Team, type: :model do
  it_behaves_like 'HasSeason'

  describe 'associations' do
    it { is_expected.to belong_to(:project).optional }

    it { is_expected.to have_many(:applications).dependent(:nullify).inverse_of(:team) }
    it { is_expected.to have_many(:application_drafts).dependent(:nullify) }

    it { is_expected.to have_many(:activities).dependent(:destroy) }
    it { is_expected.to have_many(:sources).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }

    it { is_expected.to have_many(:roles).dependent(:destroy).inverse_of(:team) }
    it { is_expected.to have_many(:members).through(:roles).source(:user) }
    it { is_expected.to have_many(:students).through(:roles).source(:user) }
    it { is_expected.to have_many(:coaches).through(:roles).source(:user) }
    it { is_expected.to have_many(:mentors).through(:roles).source(:user) }
    it { is_expected.to have_many(:helpdesks).through(:roles).source(:user) }
    it { is_expected.to have_many(:organizers).through(:roles).source(:user) }
    it { is_expected.to have_many(:supervisors).through(:roles).source(:user) }

    it { is_expected.to have_many(:status_updates).class_name('Activity').conditions(kind: 'status_update') }

    it { is_expected.to have_many(:conference_attendances).dependent(:destroy) }
    it { is_expected.to have_one(:conference_preference).dependent(:destroy) }
    it { is_expected.to have_one(:last_activity).class_name('Activity').order('id DESC') }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_uniqueness_of(:name) }

    describe 'multiple team memberships' do
      let!(:existing_team) { role.team }
      let(:role)   { create "#{role_name}_role" }
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
      let(:new_student) { -> { { name: 'student', team_id: team.id, user_id: new_user.id } } }
      let(:new_student_as_coach) { -> { { name: 'coach', team_id: team.id, user_id: new_user.id } } }
      let(:second_new_student) { -> { { name: 'student', team_id: team.id, user_id: create(:user).id } } }
      let(:third_new_student) { -> { { name: 'student', team_id: team.id, user_id: create(:user).id } } }
      let(:remove_student) { -> { { name: 'student', team_id: team.id, user_id: create(:user).id, _destroy: true } } }

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

    describe 'limit of coaches' do
      let(:team) { create :team }
      let(:new_user) { create :user }
      let(:coach_attributes) do
        [{ name: 'coach', team_id: team.id, user_id: new_user.id }] + \
          3.times.map { { name: 'coach', team_id: team.id, user_id: create(:user).id } }
      end
      let(:new_coach_as_student) { { name: 'student', team_id: team.id, user_id: new_user.id } }
      let(:fifth_new_coach) { { name: 'coach', team_id: team.id, user_id: create(:user).id } }
      let(:remove_coach) { { name: 'coach', team_id: team.id, user_id: create(:user).id, _destroy: true } }

      context 'when team has no coaches yet' do
        it 'allows to add 4 new coaches' do
          expect {
            team.update roles_attributes: coach_attributes
          }.to change { team.members.count }.by 4
        end

        it 'ignores coaches marked for destruction' do
          roles_attributes = coach_attributes
          roles_attributes << remove_coach
          expect {
            team.update roles_attributes: roles_attributes
          }.to change { team.members.count }.by 4
        end

        it 'does not allow to add more than 5 new coaches' do
          roles_attributes = coach_attributes
          roles_attributes << fifth_new_coach
          team.attributes = { roles_attributes: roles_attributes }
          expect { team.save }.not_to change { team.members.count }
          expect(team.errors[:roles].first).to eql 'there cannot be more than 4 coaches on a team.'
        end

        it 'does not allow the same coach to fill up both spots' do
          roles_attributes = 2.times.map { coach_attributes.first }
          team.attributes = { roles_attributes: roles_attributes }
          expect { team.save }.not_to change { team.members.count }
          expect(team.errors[:base].first).to eql "#{new_user.name} can't have more than one role in this team!"
        end

        it 'does not allow the same coach to add themselves as a student' do
          roles_attributes = [coach_attributes.first, new_coach_as_student]
          team.attributes = { roles_attributes: roles_attributes }
          expect { team.save }.not_to change { team.members.count }
          expect(team.errors[:base].first).to eql "#{new_user.name} can't have more than one role in this team!"
        end
      end

      context 'when team has coaches' do
        let!(:existing_coaches) { create_list :coach_role, 4, team: team }
        before { team.reload }

        it 'does not allow to add new coaches' do
          roles_attributes = [coach_attributes.first]
          team.attributes = { roles_attributes: roles_attributes }
          expect { team.save }.not_to change { team.members.count }
          expect(team.errors[:roles].first).to eql 'there cannot be more than 4 coaches on a team.'
        end

        it 'allows to remove existing coach and add new' do
          roles_attributes = [{ id: existing_coaches.first.id, _destroy: true }, coach_attributes.first]
          expect {
            team.update roles_attributes: roles_attributes
          }.not_to change { team.coaches.count }
          expect(team.coaches).not_to include existing_coaches.first
        end

        it 'allows to edit role of existing coach and add new' do
          roles_attributes = [{ id: existing_coaches.first.id, name: 'student' }, coach_attributes.first]
          expect {
            team.update roles_attributes: roles_attributes
          }.not_to change { team.coaches.count }
          expect(team.coaches).not_to include existing_coaches.first
        end
      end
    end
  end

  describe '#coaches_confirmed?' do
    let(:role) { create "#{role_name}_role" }
    let(:role_name) { 'coach' }
    let(:member) { role.user }
    let(:user) { create(:user) }
    let(:team) { create(:team) }
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
    let(:team) { create(:team) }
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

  describe 'scopes' do
    let!(:full_time) { create(:team, kind: 'full_time') }
    let!(:sponsored) { create(:team, kind: 'sponsored') }
    let!(:part_time) { create(:team, kind: 'part_time') }
    let!(:voluntary) { create(:team, kind: 'voluntary') }

    let!(:nil_kind)            { create(:team, kind: nil) }
    let!(:invisible)           { create(:team, kind: nil, invisible: true) }
    let!(:invisible_full_time) { create(:team, invisible: true, kind: 'full_time') }

    describe '.full_time' do
      subject(:teams) { described_class.full_time }

      it 'returns teams of kind full_time and sponsored (legacy term)' do
        expect(teams).to contain_exactly(full_time, sponsored, invisible_full_time)
      end
    end

    describe '.part_time' do
      subject(:teams) { described_class.part_time }

      it 'returns teams of kind part_time and voluntary (legacy term)' do
        expect(teams).to contain_exactly(part_time, voluntary)
      end
    end

    describe '.accepted' do
      subject(:teams) { described_class.accepted }

      it 'returns all full- and part-time teams (and their legacy versions)' do
        expect(teams).to contain_exactly(
          part_time, voluntary, sponsored, full_time, invisible_full_time
        )
      end
    end

    describe '.visible' do
      subject(:teams) { described_class.visible }

      it 'excludes non-accepted and explicitly set to invisible teams' do
        expect(teams).to contain_exactly(
          part_time, voluntary, sponsored, full_time, invisible_full_time, nil_kind
        )
      end
    end

    describe '.by_season' do
      let(:season2016)  { create(:season, name: '2016') }
      let(:season2015)  { create(:season, name: '2015') }
      let!(:teams2016)  { create_list(:team, 2, season: season2016) }

      before { create(:team, season: season2015) }

      context 'when passing the year as an integer' do
        subject(:teams) { described_class.by_season(2016) }

        it 'returns only teams from the given season' do
          expect(teams).to match_array(teams2016)
        end
      end

      context 'when passing the year as a string' do
        subject(:teams) { described_class.by_season('2016') }

        it 'returns only teams from the given season' do
          expect(teams).to match_array(teams2016)
        end
      end
    end

    describe '.in_nearest_season' do
      let(:current_season) { create(:season, name: Date.today.year) }
      let!(:current_teams) { create_list(:team, 2, season: current_season) }
      let(:prev_season) { create(:season, name: Date.today.year - 1) }
      let!(:prev_teams) { create_list(:team, 2, season: prev_season) }

      subject(:returned_teams) { described_class.in_nearest_season }

      context 'when current season has teams' do
        it 'returns those teams' do
          expect(returned_teams).to match_array(current_teams)
        end
      end

      context 'when current season has no teams' do
        before { current_teams.each(&:destroy) }

        it 'returns last season\'s teams' do
          expect(returned_teams).to match_array(prev_teams)
        end
      end
    end
  end

  describe 'creating a new team' do
    before { described_class.destroy_all }

    subject(:team) { create :team }

    it 'sets the team number' do
      expect(team.reload.number).to eql 1
    end
  end

  describe '#display_name' do
    subject(:display_name) { team.display_name }

    let(:team)    { build(:team, :in_current_season, name: 'Blue') }
    let(:project) { build(:project, name: 'Sinatra') }

    it 'returns "Team" and the name' do
      expect(display_name).to eq('Team Blue')
    end

    context 'when the name already contains "Team"' do
      let(:team) { build(:team, name: 'Team Paperplane') }

      it 'does no prepend "Team"' do
        expect(display_name).to eq('Team Paperplane')
      end
    end

    context 'with a project assigned' do
      before { team.project = project }

      it 'prepends the project name' do
        expect(display_name).to eq('Team Blue (Sinatra)')
      end
    end

    context 'when from a past season' do
      let(:team)   { build(:team, name: 'Cheesy', season: season, project: project) }
      let(:season) { build(:season, name: '1999') }

      it 'appends the season name' do
        expect(display_name).to eq('Team Cheesy (Sinatra) [1999]')
      end
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
    let(:user) { create(:user) }

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

    it 'returns true for a full_time team' do
      subject.kind = 'full_time'
      expect(subject).to be_accepted
    end

    it 'returns true for a part_time team' do
      subject.kind = 'part_time'
      expect(subject).to be_accepted
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

  describe '#student_index' do
    let(:team)      { create(:team) }
    let!(:students) { create_list(:student, 2, team: team) }

    it 'returns 0 for the student with the smaller id' do
      expect(team.student_index students.first).to eq 0
    end

    it 'returns 1 for the student with the greater id' do
      expect(team.student_index students.second).to eq 1
    end

    it 'returns 0 if the user is not part of the team' do
      other_user = instance_double(User, id: 666)
      expect(team.student_index other_user).to be_nil
    end
  end
end
