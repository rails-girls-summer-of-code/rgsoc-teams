require 'rails_helper'

RSpec.describe ConferenceAttendance, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to belong_to(:conference) }
end
