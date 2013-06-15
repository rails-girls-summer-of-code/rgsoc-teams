require 'spec_helper'

describe Repository do
  it { should belong_to(:team) }
  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }
end
