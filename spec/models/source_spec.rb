require 'spec_helper'

describe Source do
  it { should belong_to(:team) }
  it { should validate_presence_of(:url) }
  it { should validate_uniqueness_of(:url) }
end
