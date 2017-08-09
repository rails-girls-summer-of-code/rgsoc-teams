require 'spec_helper'

describe ConferenceAttendance do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:conference) }
end