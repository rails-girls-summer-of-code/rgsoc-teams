require 'spec_helper'

describe Role do
  it { should belong_to(:team) }
  it { should belong_to(:member) }
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:team_id) }
  it { should validate_presence_of(:name) }
  it { should ensure_inclusion_of(:name).in_array(Role::ROLES) }
end
