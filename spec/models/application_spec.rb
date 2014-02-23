require 'spec_helper'

describe Application do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:application_data) }
end
