require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]
RSpec.describe Ability, type: :model do

  let(:user) { create(:user) }
  subject(:ability) { Ability.new(user) }

  describe "Confirmed user" do

    it_behaves_like "same as logged in user"
    it_behaves_like "can create a Project"
    it_behaves_like "can see mailings list too"
    it_behaves_like "can read mailings sent to them"
    it_behaves_like "can comment now" # not implemented; false positives; needs work
    it { expect(subject).to be_able_to([:join, :create], Team) }

  end
end
