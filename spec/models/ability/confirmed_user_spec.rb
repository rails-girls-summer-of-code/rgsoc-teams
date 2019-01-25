require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]
RSpec.describe Ability, type: :model do
  let(:user) { build_stubbed(:user) }
  subject(:ability) { Ability.new(user) }
  let(:other_user) { build_stubbed(:user) }
  let(:hidden) { build_stubbed(:user, hide_email: true) }

  describe "Confirmed user" do
    it_behaves_like 'has access to public features'

    # same as unconfirmed:
    it "can modify own account" do
      expect(subject).to be_able_to([:update, :destroy], user)
      expect(subject).to be_able_to(:resend_confirmation_instruction, User, id: user.id)
    end
    it { expect(subject).not_to be_able_to([:update, :destroy], other_user) }

    # the perks of confirming
    it { expect(subject).to be_able_to(:read_email, other_user) }
    it { expect(subject).not_to be_able_to(:read_email, hidden) }
    it { expect(subject).to be_able_to([:join, :create], Team) }
    it { expect(subject).to be_able_to(:create, Comment) } # TODO needs work for polymorphism
    it { expect(subject).to be_able_to(:create, Project) }
    it { expect(subject).to be_able_to(:index, Mailing) }
    it { expect(subject).to be_able_to(:read, Mailing, recipient: user) }
  end
end
