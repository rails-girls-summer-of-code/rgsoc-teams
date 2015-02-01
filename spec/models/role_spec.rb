require 'spec_helper'

describe Role do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:user) }
  it { is_expected.to validate_presence_of(:user) }
  it { is_expected.to validate_presence_of(:name) }
  it { is_expected.to ensure_inclusion_of(:name).in_array(Role::ROLES) }
  it { is_expected.to validate_uniqueness_of(:user_id).scoped_to([:team_id, :name]) }

  describe 'application' do
    it 'includes role name' do
      FactoryGirl.create(:student_role)
      expect(Role.includes?('student')).to eq true
    end
  end
end
