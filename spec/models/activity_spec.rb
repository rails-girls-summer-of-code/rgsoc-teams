require 'spec_helper'

describe Activity do
  it { should belong_to(:team) }
end
