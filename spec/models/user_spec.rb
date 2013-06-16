require 'spec_helper'

describe User do
  it { should have_many(:teams) }
  it { should have_many(:roles) }
  it { should validate_presence_of(:github_handle) }
  it { should validate_uniqueness_of(:github_handle) }
  # it { should validate_uniqueness_of(:email) }
end
