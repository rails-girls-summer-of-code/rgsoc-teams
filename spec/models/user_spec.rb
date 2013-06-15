require 'spec_helper'

describe User do
  it { should belong_to(:team) }
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:location) }
  it { should ensure_inclusion_of(:role).in_array(User::ROLES) }
end
