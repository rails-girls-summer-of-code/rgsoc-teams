require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]
RSpec.describe Ability, type: :model do
  let(:user) { nil }
  subject(:ability) { Ability.new(user) }

  let(:other_user) { build_stubbed(:user) }

  describe "Guest User" do
    it_behaves_like 'has access to public features'

    it { expect(subject).not_to be_able_to(:read_email, other_user) }

    it "can not modify things on public pages" do
      PUBLIC_INDEX_PAGES.each do |page|
        expect(subject).not_to be_able_to([:create, :update, :destroy], page)
      end
    end

    it { expect(subject).not_to be_able_to(:create, Comment) }
  end
end
