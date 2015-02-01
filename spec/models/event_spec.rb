require 'spec_helper'

describe Event do
  it { is_expected.to have_many(:teams) }
end
