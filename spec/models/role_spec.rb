require 'spec_helper'

RSpec.describe Role do
  let(:user) { create(:user) }
  let(:team) { create(:team) }

  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_inclusion_of(:name).in_array(Role::ROLES) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:team_id, :name]) }

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

      it 'does not send a notification' do
        expect(RoleMailer).to_not have_received(:user_added_to_team).with(subject)
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
end
