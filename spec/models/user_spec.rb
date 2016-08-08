require 'spec_helper'

describe User do
  before do
    stub_request(:get, /./).to_return(body: File.read('spec/stubs/github/user.json'))
  end

  it { expect(subject).to have_many(:teams) }
  it { expect(subject).to have_many(:application_drafts) }
  it { expect(subject).to have_many(:attendances) }
  it { expect(subject).to have_many(:conferences) }
  it { expect(subject).to have_many(:roles) }
  it { expect(subject).to validate_presence_of(:github_handle) }
  it { is_expected.to validate_uniqueness_of(:github_handle).case_insensitive }

  it { expect(subject).to allow_value('http://example.com').for(:homepage) }
  it { expect(subject).to allow_value('https://example.com').for(:homepage) }
  it { expect(subject).to_not allow_value('example.com').for(:homepage) }

  describe 'scopes' do
    before do
      @user1 = create(:user)
      @user2 = create(:coach)

      Role.find_by(name: 'coach', user_id: @user2.id).team.update_attribute(:kind, 'Charity')
    end

    describe 'roles scopes and methods' do
      before do
        @organizer = create(:organizer)
        @role = Role.find_by(name: 'organizer', user_id: @organizer.id)
      end

      context 'admin scope' do
        it 'returns admin roles of the user' do
          expect(@organizer.roles.admin).to eq([@role])
        end
      end

      context 'organizer check' do
        it 'checks if organizer' do
          expect(@organizer.roles.organizer).to eq([@role])
        end
      end

      it 'returns true for roles.includes?' do
        expect(@organizer.roles.includes?('organizer')).to eql true
      end
    end

    describe 'supervisor check' do
      before do
        @supervisor = create(:supervisor)
        @role = Role.find_by(name: 'supervisor', user_id: @supervisor.id)
      end

      context 'supervisor check' do
        it 'expects to be supervisor' do
          expect(@supervisor.roles.supervisor).to eq([@role])
        end
      end
    end

    describe '.find_for_github_oauth' do
      context 'with github_handle' do
        let(:handle) { "Foobar_#{SecureRandom.hex(8)}" }
        let!(:user) { create :user, github_handle: handle }

        it 'finds user case-insensitively' do
          auth = double('Fake auth', uid: 1234)
          allow(auth).to receive_message_chain('extra.raw_info.login').and_return(handle.upcase)

          expect(described_class.find_for_github_oauth(auth)).to eql user
        end
      end
    end

    describe '.with_assigned_roles' do
      it 'returns users that have any roles assigned' do
        expect(described_class.with_assigned_roles).to be ==[@user2]
      end
    end

    describe '.with_role' do
      it 'returns users that have matching role name' do
        expect(described_class.with_role('coach')).to be ==[@user2]
      end

      it 'allows a list of roles' do
        organizer = create(:organizer)
        expect(described_class.with_role('coach', 'organizer')).to be ==[@user2, organizer]
      end
    end

    describe '.with_team_kind' do
      it 'returns users that have matching team kind' do
        expect(described_class.with_team_kind('Charity')).to be ==[@user2]
      end
    end

    describe '.with_interest' do
      let(:user) { create(:user) }

      it 'returns users matching one out of many interests' do
        user.update interested_in: %w(coaches pairs helpdesk)
        expect(User.with_interest('helpdesk')).to eq [user]
      end
    end
  end

  describe 'before_save' do
    before { subject.github_handle = 'octocat' }

    context 'sanitizing the location' do
      before do
        allow_any_instance_of(Github::User).
          to receive(:attrs).and_return({ location: '' })
      end

      it 'leaves an undefiend location untouched' do
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
    end
  end

  describe 'after_create' do
    let(:user) { User.create(github_handle: 'octocat') }

    it 'is just created' do
      expect(user.just_created?).to eql true
    end

    it 'completes attributes from Github' do
      attrs = user.attributes.slice(*%w(github_id email location name))
      expect(attrs.values).to be == [1, 'octocat@github.com', 'San Francisco', 'monalisa octocat']
    end

    it 'sets the name to the github_handle if blank' do
      allow_any_instance_of(Github::User).
        to receive(:attrs).and_return({ name: '' })
      expect(user.name).to eql user.github_handle
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
      expect(@user.name_or_handle).to be =='trung'
    end

    it 'returns github_handle if name is not available' do
      @user = described_class.new(github_handle: 'rails-girl')
      expect(@user.name_or_handle).to be =='rails-girl'
    end
  end

  describe '#student?' do
    it 'returns false for users w/o a role' do
      expect(subject).not_to be_student
    end

    it 'returns true if user has a student role' do
      student = FactoryGirl.create(:student)
      expect(student).to be_student
    end
  end

  describe '#supervisor?' do
    it 'returns false for users w/o a role' do
      expect(subject).not_to be_supervisor
    end

    it 'returns true if user has a supervisor role' do
      supervisor = FactoryGirl.create(:supervisor)
      expect(supervisor).to be_supervisor
    end
  end


  describe '#current_student?' do
    it 'returns false for users w/o a role' do
      expect(subject).not_to be_current_student
    end

    it 'returns false if user has a random student role' do
      student = FactoryGirl.create(:student)
      expect(student).not_to be_current_student
    end

    it 'returns false if user\'s team has not been accepted' do
      team    = FactoryGirl.create(:team, :in_current_season, kind: nil)
      student = FactoryGirl.create(:student, team: team)
      expect(student).not_to be_current_student
    end

    it 'returns true if user is among this season\'s accepted students' do
      team    = FactoryGirl.create(:team, :in_current_season, kind: 'sponsored')
      student = FactoryGirl.create(:student, team: team)
      expect(student).to be_current_student
    end
  end

  describe 'Search for user names and team names' do
    before do
      @cruyff = FactoryGirl.create(:user, name: "Johan Cruyff")
      @eesy = FactoryGirl.create(:user, name: "Eesy Peesy")
      @team = FactoryGirl.create(:team, name: "Cheesy")
      @cheesy = FactoryGirl.create(:student, team: @team)

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
    let!(:user) { FactoryGirl.create(:user) }
    let!(:team) { FactoryGirl.create(:team) }
    let!(:coach) { FactoryGirl.create(:coach_role, team: team, user: user) }
    let!(:mentor) { FactoryGirl.create(:mentor_role, team: team, user: user) }

    it 'lists unique teams even with different roles' do
      expect(user.teams.count).to eql 1
    end
  end
end
