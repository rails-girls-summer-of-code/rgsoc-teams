require 'spec_helper'

describe Team do
  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end