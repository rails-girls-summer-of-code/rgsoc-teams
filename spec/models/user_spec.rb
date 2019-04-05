require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    stub_request(:get, /./).to_return(body: File.read('spec/stubs/github/user.json'))
  end

  describe 'associations' do
    it { is_expected.to have_many(:roles) }
    it { is_expected.to have_many(:teams).through(:roles) }
    it { is_expected.to have_many(:application_drafts).through(:teams) }
    it { is_expected.to have_many(:applications).through(:teams) }
    it { is_expected.to have_many(:todos).dependent(:destroy) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  describe 'validations' do
    it { expect(subject).to validate_presence_of(:github_handle) }
    it { is_expected.to validate_uniqueness_of(:github_handle).case_insensitive }

    it { expect(subject).to allow_value('http://example.com').for(:homepage) }
    it { expect(subject).to allow_value('https://example.com').for(:homepage) }
    it { expect(subject).to_not allow_value('example.com').for(:homepage) }

    it { expect(subject).to validate_presence_of(:name) }
    it { expect(subject).to validate_presence_of(:email) }
    it { expect(subject).to validate_presence_of(:country) }
    it { expect(subject).to validate_presence_of(:location) }

    context 'during github user import' do
      before do
        subject.github_import = true
      end

      it { expect(subject).not_to validate_presence_of(:name) }
      it { expect(subject).not_to validate_presence_of(:email) }
      it { expect(subject).not_to validate_presence_of(:country) }
      it { expect(subject).not_to validate_presence_of(:location) }

      it 'should not send a confirmation email' do
        expect {
          subject.github_handle = "example"
          subject.github_import = true
          subject.save!
        }.not_to change { ActionMailer::Base.deliveries.count }
        subject.reload
      end
    end
  end

  describe 'email preferences' do
    let(:now) { Time.new(2002, 10, 31) }
    let(:user) { build(:user, github_handle: 'github_handle') }
    before { Timecop.freeze(now) }
    after { Timecop.return }

    shared_examples 'opting in and out' do |optin|
      it 'sets the time opted in at' do
        user.public_send("#{optin}=", true)
        user.save!
        expect(user.public_send("#{optin}_at")).to eq(now)
        user.public_send("#{optin}=", false)
        user.save!
        expect(user.public_send("#{optin}_at")).not_to be_present
      end
    end

    it_behaves_like 'opting in and out', :opted_in_newsletter
    it_behaves_like 'opting in and out', :opted_in_announcements
    it_behaves_like 'opting in and out', :opted_in_marketing_announcements
    it_behaves_like 'opting in and out', :opted_in_surveys
    it_behaves_like 'opting in and out', :opted_in_sponsorships
    it_behaves_like 'opting in and out', :opted_in_applications_open
  end

  describe 'immutable github handle validation' do
    context 'when creating a new user' do
      let(:new_user) { build(:user, github_handle: 'github_handle') }

      it 'allows creating a user with given github handle' do
        expect(new_user).to be_valid
      end
    end

    context 'when updating an existing user' do
      let(:existing_user) { create(:user) }

      it 'doesn\'t allow to change user\'s github handle' do
        existing_user.update(github_handle: 'new_github_handle')
        expect(existing_user.errors.messages[:github_handle]).to eq(['can\'t be changed'])
      end
    end
  end

  describe 'scopes' do
    context 'role scopes' do
      describe '.organizer' do
        let!(:user) { create(:organizer) }
        let(:role)  { Role.find_by(name: 'organizer', user_id: user.id) }

        it 'returns admin role for user' do
          expect(user.roles.admin).to contain_exactly(role)
        end

        it 'returns orga role for user' do
          expect(user.roles.organizer).to contain_exactly(role)
        end
      end

      describe '.supervisor' do
        let!(:user) { create(:supervisor) }
        let(:role)  { Role.find_by(name: 'supervisor', user_id: user.id) }

        it 'does not return admin role for user' do
          expect(user.roles.admin).to be_empty
        end

        it 'returns supervisor role for user' do
          expect(user.roles.supervisor).to contain_exactly(role)
        end
      end

      describe '.reviewer' do
        let!(:user) { create(:reviewer) }
        let(:role)  { Role.find_by(name: 'reviewer', user_id: user.id) }

        it 'does not return admin role for user' do
          expect(user.roles.admin).to be_empty
        end

        it 'returns reviewer role for user' do
          expect(user.roles.reviewer).to contain_exactly(role)
        end
      end
    end

    context 'user scopes' do
      let!(:coach) { create(:coach) }
      let!(:user)  { create(:user) }

      describe '.find_for_github_oauth' do
        let(:handle) { "Foobar_#{SecureRandom.hex(8)}" }
        let!(:user)  { create :user, github_handle: handle }

        it 'finds user case-insensitively' do
          auth = double('Fake auth', uid: 1234)
          allow(auth).to receive_message_chain('extra.raw_info.login').and_return(handle.upcase)

          expect(described_class.find_for_github_oauth(auth)).to eql user
        end
      end

      describe '.with_interest' do
        it 'returns users matching one out of many interests' do
          user.update interested_in: %w(coaches pairs helpdesk)
          expect(User.with_interest('helpdesk')).to contain_exactly(user)
        end
      end

      describe '.with_assigned_roles' do
        it 'returns users that have any roles assigned' do
          expect(described_class.with_assigned_roles).to contain_exactly(coach)
        end
      end

      describe '.with_role' do
        it 'returns users that have matching role name' do
          expect(described_class.with_role('coach')).to contain_exactly(coach)
        end

        it 'allows a list of roles' do
          organizer = create(:organizer)
          expect(described_class.with_role('coach', 'organizer')).to contain_exactly(coach, organizer)
        end
      end

      describe '.with_team_kind' do
        it 'returns users that have matching team kind' do
          Role.find_by(name: 'coach', user_id: coach.id).team.update_attribute(:kind, 'Charity')
          expect(described_class.with_team_kind('Charity')).to contain_exactly(coach)
        end
      end
    end
  end

  describe 'before_save' do
    before do
      subject.github_handle = 'octocat'
      subject.confirmed_at  = Date.yesterday
      subject.github_import = true
    end

    context 'sanitizing the location' do
      before do
        allow_any_instance_of(Github::User).
          to receive(:attrs).and_return({ location: '' })
      end

      it 'leaves an undefined location untouched' do
        expect { subject.save }.not_to change { subject.location }.from(nil)
      end

      it 'leaves a meaningful location untouched' do
        subject.location = 'Testvalley'
        expect { subject.save }.not_to change { subject.location }
      end

      it 'unsets a blank location' do
        subject.location = '  '
        expect { subject.save }.to change { subject.location }.to(nil)
      end

      it 'unifies the location format' do
        subject.location = "nEw york"
        expect { subject.save }.to change { subject.location }.to("New York")
      end

      it 'does not separate words with foul caps' do
        subject.location = "AMSterdam"
        expect { subject.save }.to change { subject.location }.to("Amsterdam")
      end

      it 'cannot correct invalid input' do
        subject.location = "Asterdam"
        expect { subject.save }.not_to change { subject.location }
      end
    end
  end

  describe 'before_create' do
    subject(:user) { described_class.create(attrs) }

    let(:attrs)         { { github_handle: github_handle, confirmed_at: Date.yesterday, github_import: true } }
    let(:github_handle) { 'octocat' }

    it { is_expected.to be_just_created }

    it 'completes attributes from Github and writes them to the DB' do
      expect(user.reload).to have_attributes(
        github_id: 1,
        email:     'octocat@github.com',
        name:      'monalisa octocat',
        location:  'San Francisco'
      )
    end

    context 'when the name cannot be retrieved from Github' do
      let(:github_user) { instance_double(Github::User) }
      let(:empty_attrs) { { name: '' } }

      before do
        allow(Github::User).to receive(:new).with(github_handle).and_return(github_user)
        allow(github_user).to receive(:attrs).and_return(empty_attrs)
      end

      it 'sets the name to the github handle' do
        expect(user.reload).to have_attributes(name: github_handle, github_handle: github_handle)
        expect(github_user).to have_received(:attrs)
      end
    end
  end

  describe '#github_url' do
    it 'returns github url' do
      @user = described_class.new(github_handle: 'rails-girl')
      expect(@user.github_url).to be == 'https://github.com/rails-girl'
    end
  end

  describe '#name_or_handle' do
    it 'returns name if existed' do
      @user = described_class.new(name: 'trung')
      expect(@user.name_or_handle).to be == 'trung'
    end

    it 'returns github_handle if name is not available' do
      @user = described_class.new(github_handle: 'rails-girl')
      expect(@user.name_or_handle).to be == 'rails-girl'
    end
  end

  describe '#admin?' do
    it 'returns false for users w/o admin role' do
      student = create(:student)
      expect(student).not_to be_admin
    end

    it 'returns true if user has a admin role' do
      supervisor = create(:supervisor)
      create(:organizer_role, user: supervisor)
      expect(supervisor).to be_admin
    end
  end

  describe '#mentor?' do
    it 'returns false for users w/o mentor role' do
      student = create(:student)
      expect(student).not_to be_mentor
    end

    it 'returns true if user has a mentor role' do
      mentor = create(:mentor)
      create(:organizer_role, user: mentor)
      expect(mentor).to be_mentor
    end
  end

  describe '#project_maintainer?' do
    let!(:maintainer) { create(:user) }

    it 'returns false for users who did not submit a project' do
      student = create(:student)
      expect(student).not_to be_project_maintainer
    end

    it 'returns true if user is maintaining an accepted project' do
      create(:maintainership, project: create(:project, :accepted), user: maintainer)
      expect(maintainer).to be_project_maintainer
    end

    it 'returns false if user has submitted a rejected project' do
      create(:project, :rejected, submitter: maintainer)
      expect(maintainer).not_to be_project_maintainer
    end

    it 'returns false if user has just proposed a project' do
      create(:project, submitter: maintainer)
      expect(maintainer).not_to be_project_maintainer
    end
  end

  describe '#reviewer?' do
    it 'returns false for users w/o a role' do
      expect(subject).not_to be_reviewer
    end

    it 'returns true if user has a reviewer role' do
      reviewer = create(:reviewer)
      expect(reviewer).to be_reviewer
    end
  end

  describe '#student?' do
    it 'returns false for users w/o a role' do
      expect(subject).not_to be_student
    end

    it 'returns true if user has a student role' do
      student = create(:student)
      expect(student).to be_student
    end
  end

  describe '#supervisor?' do
    it 'returns false for users w/o a role' do
      expect(subject).not_to be_supervisor
    end

    it 'returns true if user has a supervisor role' do
      supervisor = create(:supervisor)
      expect(supervisor).to be_supervisor
    end
  end

  describe '#current_student?' do
    it 'returns false for users w/o a role' do
      expect(subject).not_to be_current_student
    end

    it 'returns false if user has a random student role' do
      student = build(:student)
      expect(student).not_to be_current_student
    end

    it 'returns false if user\'s team has not been accepted' do
      team    = create(:team, :in_current_season, kind: nil)
      student = create(:student, team: team)
      expect(student).not_to be_current_student
    end

    it 'returns true if user is among this season\'s accepted students' do
      team    = create(:team, :in_current_season, kind: 'part_time')
      student = create(:student, team: team)
      expect(student).to be_current_student
    end
  end

  describe 'Search for user names and team names' do
    before do
      @cruyff = create(:user, name: "Johan Cruyff")
      @eesy = create(:user, name: "Eesy Peesy")
      @team = create(:team, name: "Cheesy")
      @cheesy = create(:student, team: @team)
    end

    it 'returns user with matching name' do
      expect(User.search("ruyf")).to eq [@cruyff]
    end
    it 'does not return user with non-matching name' do
      expect(User.search("max")).not_to eq [@cruyff]
    end
    it 'searches case insensitive' do
      expect(User.search("cRUyfF")).to eq [@cruyff]
    end
    it 'returns team with matching name' do
      expect(User.search("chees")).to eq [@cheesy]
    end
    it 'returns users and teams with matching name' do
      expect(User.search("eesy")).to eq [@eesy, @cheesy]
    end
    it 'returns all when search string is empty' do
      expect(User.search("").count).to be == 3
    end
  end

  context 'with roles' do
    let!(:user) { create(:user) }
    let!(:team) { create(:team) }
    let!(:coach) { create(:coach_role, team: team, user: user) }
    let!(:mentor) { create(:mentor_role, team: team, user: user) }

    it 'lists unique teams even with different roles' do
      expect(user.teams.count).to eql 1
    end
  end
end
