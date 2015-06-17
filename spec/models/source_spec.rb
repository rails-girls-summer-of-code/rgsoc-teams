require 'spec_helper'

describe Source do
  it { is_expected.to belong_to(:team) }
  #it { is_expected.to validate_presence_of(:url) }
end
