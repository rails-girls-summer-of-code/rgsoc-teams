require 'spec_helper'

describe FeedEntry do
  it { should belong_to(:team) }
end
