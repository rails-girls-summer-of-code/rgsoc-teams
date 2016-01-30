require 'spec_helper'

describe Role do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to validate_inclusion_of(:name).in_array(Role::ROLES) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:team_id, :name]) }

  describe 'application' do
    it 'includes role name' do
      FactoryGirl.create(:student_role)
      expect(Role.includes?('student')).to eq true
    end
  end

  describe 'create' do
    let(:user) { FactoryGirl.create(:user) }
    let(:team) { FactoryGirl.create(:team) }
    let(:mailer) { double('RoleMailer') }

    before do
      allow(RoleMailer).to receive(:user_added_to_team).and_return(mailer)
      allow(mailer).to receive(:deliver_later)
      subject
    end

    shared_examples 'a guide role' do
      it 'sends a notification to the user' do
        expect(RoleMailer).to have_received(:user_added_to_team).with(subject)
        expect(mailer).to have_received(:deliver_later)
      end
    end

    subject do
      user.roles.create team: team, name: role_name
    end

    context 'when the user is added as a student' do
      let(:role_name) { 'student' }

      it 'does not send a notification' do
        expect(RoleMailer).to_not have_received(:user_added_to_team).with(subject)
      end
    end

    context 'when the user is added as a coach' do
      let(:role_name) { 'coach' }

      it_behaves_like 'a guide role'
    end

    context 'when the user is added as a coach' do
      let(:role_name) { 'mentor' }

      it_behaves_like 'a guide role'
    end
  end
end
