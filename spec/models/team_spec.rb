require 'spec_helper'

describe Team do
  it { should have_many(:repositories) }
  it { should have_many(:members) }
  it { should have_many(:students) }
  it { should have_many(:coaches) }
  it { should have_many(:mentors) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end