require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]
RSpec.describe Ability, type: :model do

  let(:user){ nil }
  subject(:ability) { Ability.new(user) }

  let(:other_user) { build_stubbed(:user) }

  describe "Guest User" do
    it_behaves_like "can view public pages"
    it_behaves_like "can not modify things on public pages"
    it_behaves_like "can not create new user"
    it_behaves_like "can not comment"
    it_behaves_like "has no access to other user's accounts"
    it_behaves_like "can not read role restricted or owner restricted pages"
  end
end
