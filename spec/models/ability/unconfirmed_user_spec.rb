require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]

RSpec.describe Ability, type: :model do
  describe "User logged in, account unconfirmed" do
    let(:user) { create(:user, :unconfirmed) }
    let(:other_user) { create(:user) }
    subject(:ability) { Ability.new(user) }

    it_behaves_like 'has access to public features'

    it { expect(subject).not_to be_able_to(:read_email, other_user) }

    it "can not modify things on public pages" do
      PUBLIC_INDEX_PAGES.each do |page|
        expect(subject).not_to be_able_to([:create, :update, :destroy], page)
      end
    end

    it { expect(subject).not_to be_able_to(:create, Comment) }

    it "can modify own account" do
      expect(subject).to be_able_to([:update], user)
      expect(subject).to be_able_to(:destroy, user)
      expect(subject).to be_able_to(:resend_confirmation_instruction, User, id: user.id)
    end
  end
end
