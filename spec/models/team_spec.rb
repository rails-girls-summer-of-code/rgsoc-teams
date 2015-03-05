require 'spec_helper'

describe Team do
  subject { Team.new(kind: 'sponsored') }

  it { is_expected.to have_many(:activities) }
  it { is_expected.to have_one(:project) }
  it { is_expected.to have_many(:sources) }
  it { is_expected.to have_many(:members) }
  it { is_expected.to have_many(:students) }
  it { is_expected.to have_many(:coaches) }
  it { is_expected.to have_many(:mentors) }
  it { is_expected.to have_many(:helpdesks) }
  it { is_expected.to have_many(:organizers) }
  it { is_expected.to have_many(:supervisors) }
  it { is_expected.to have_many(:roles) }

  it { is_expected.to validate_uniqueness_of(:name) }

  context 'multiple team memberships' do
    let!(:existing_team) { role.team }
    let(:role)   { FactoryGirl.create "#{role_name}_role" }
    let(:member) { role.user }
    let(:user) { create(:user) }
    let(:team) { FactoryGirl.create(:team) }
    let(:roles_attributes) { [{ name: role_name, team_id: team.id, user_id: member.id }] }

    context 'for students' do
      let(:role_name) { 'student' }

      it 'allows no more than one team as a student' do
        team.attributes = { roles_attributes: roles_attributes }
        expect { team.save }.not_to change { team.members.count }
        expect(team.errors[:roles].first).to eql "#{member.name} already is a student on another team."
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

      it 'allows team membership in different seasons' do
        skip
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

  it_behaves_like 'HasSeason'

  describe 'creating a new team' do
    before do
      Team.destroy_all
      subject.save!
    end

    it 'sets the team number' do
      expect(subject.reload.number).to eql 1
    end
  end

  describe '#display_name' do
    let(:students) { [User.new(name: 'Nina'), User.new(name: 'Maya')] }
    let!(:team) { Team.new }
    let!(:project) { Project.new(name: 'Sinatra', team: team) }
    before { subject.save! }

    it 'returns "Team ?" if no name given' do
      expect(team.display_name).to be == 'Team Sinatra'
    end

    it 'returns "Team Blue" if name given' do
      team.name = 'Blue'
      expect(team.display_name).to be == 'Team Blue (Sinatra)'
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

    it 'calls set_last_checked' do
      expect(subject).to receive(:set_last_checked)
      subject.checked = user
      subject.save!
    end

    it 'changes last_checked_*' do
      expect do
        subject.checked = user
        subject.save!
      end.to change(subject, :last_checked_by) && change(subject, :last_checked_at)
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
    it { is_expected.to accept_nested_attributes_for :project }
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
