require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]
RSpec.describe Ability, type: :model do
  let(:admin) { create(:user) }
  subject(:ability) { Ability.new(admin) }

  let(:other_user) { build_stubbed(:user, hide_email: true) }

  describe "Admin" do
    before { allow(admin).to receive(:admin?).and_return true }

    it { expect(subject).not_to be_able_to(:create, User.new) } # happens only via GitHub
    # it "has access to almost everything else"
    # Only test the most exclusive, the most sensitive and the 'cannots':
    it { expect(subject).to be_able_to(:crud, Team) }
    it { expect(subject).to be_able_to([:read, :update, :destroy], User) }
    it { expect(subject).to be_able_to(:read_email, other_user) }
    it { expect(subject).to be_able_to(:read, :users_info, other_user) }
  end
end
