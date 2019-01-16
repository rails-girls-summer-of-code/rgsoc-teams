require 'rails_helper'

RSpec.describe Role, type: :model do
  let(:user) { create(:user) }
  let(:team) { create(:team) }

  it { is_expected.to belong_to(:team).optional }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_inclusion_of(:name).in_array(Role::ROLES) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:name, :team_id]) }

  describe '.includes?' do
    let!(:role) { create :student_role }

    it 'includes role name' do
      expect(Role.includes?('student')).to eq true
    end
  end

  context 'with callbacks' do
    context 'before save' do
      before { allow(subject).to receive(:valid?) { true } }

      it 'creates a confirmation token' do
        expect { subject.save }.to \
          change { subject.confirmation_token }.from nil
      end
    end
  end

  describe '#state' do
    subject { user.roles.create team: team, name: role_name }

    context 'when the user is added as a coach' do
      let(:role_name) { 'coach' }

      it 'has the pending state' do
        expect(subject).to be_pending
      end
    end

    context 'when the user is added as a student' do
      let(:role_name) { 'student' }

      it 'has the confirmed state' do
        expect(subject).to be_confirmed
      end
    end

    context 'when the user is added as a mentor' do
      let(:role_name) { 'mentor' }

      it 'has the confirmed state' do
        expect(subject).to be_confirmed
      end
    end

    context 'when the user is added as a supervisor' do
      let(:role_name) { 'supervisor' }

      it 'has the confirmed state' do
        expect(subject).to be_confirmed
      end
    end
  end

  describe 'create' do
    subject { user.roles.create team: team, name: role_name }

    let(:mailer) { double('RoleMailer', deliver_later: true) }

    before do
      allow(RoleMailer).to receive(:user_added_to_team) { mailer }
      subject
    end

    context 'when the user is added as a student' do
      let(:role_name) { 'student' }

      it 'sends a notification to the user' do
        expect(RoleMailer).to have_received(:user_added_to_team).with(subject)
        expect(mailer).to have_received(:deliver_later)
      end
    end

    context 'when the user is added as a coach' do
      let(:role_name) { 'coach' }

      it 'sends a notification to the user' do
        expect(RoleMailer).to have_received(:user_added_to_team).with(subject)
        expect(mailer).to have_received(:deliver_later)
      end
    end

    context 'when the user is added as a mentor' do
      let(:role_name) { 'mentor' }

      it 'sends a notification to the user' do
        expect(RoleMailer).to have_received(:user_added_to_team).with(subject)
        expect(mailer).to have_received(:deliver_later)
      end
    end
  end

  describe '#github_handle' do
    context 'when the role has a user' do
      let(:github_handle) { 'captain_carrot_ironfoundersson' }
      before { subject.user = User.new(github_handle: github_handle) }

      it 'returns the user\'s github_handle' do
        expect(subject.github_handle).to eql github_handle
      end
    end

    context 'when the role has no user' do
      it { expect(subject.github_handle).to be_nil }
    end
  end

  describe '#github_handle=' do
    subject { described_class.new }

    context 'when argument is blank' do
      subject { build :organizer_role }

      it 'does not change the user\'s github_handle' do
        expect { subject.github_handle = '' }.not_to change { subject.user.github_handle }
      end
    end

    context 'when the role already has a user assigned' do
      subject { build :organizer_role }

      it 'changes the user' do
        expect { subject.github_handle = 'sir_samuel_vimes' }.to change { subject.user }
      end
    end

    context 'when a user with the new github_handle exists' do
      let!(:user) { create :user, github_handle: 'corporal_nobby_nobbs' }

      it 'finds and assigns the existing user' do
        expect { subject.github_handle = user.github_handle }.to change { subject.user }.to user
        expect(subject.user).to be_persisted
      end

      it 'finds user case-insensitively' do
        expect { subject.github_handle = user.github_handle.upcase }
          .to change { subject.user }.to user
      end
    end

    context 'for a previously unknown github_handle' do
      it 'initializes a new user with the requested github_handle' do
        expect { subject.github_handle = 'sir_samuel_vimes' }.to change { subject.user }.from(nil)
        expect(subject.user).to be_new_record
        expect(subject.user.github_import).to eql true
      end
    end
  end
end
