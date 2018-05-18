require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]

RSpec.describe Ability, type: :model do

  describe "User logged in, account unconfirmed" do

    let(:user){ build_stubbed(:user, :unconfirmed) }
    subject(:ability) { Ability.new(user) }

    let(:other_user) { create(:user) }

    it_behaves_like 'same as guest user'
    it_behaves_like "can modify own account"
  end
end
