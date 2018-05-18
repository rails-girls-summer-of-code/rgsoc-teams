require 'rails_helper'
require 'cancan/matchers'

# Run this file with
#   $ rspec spec/models/ability_spec.rb -fd
# to see the output of specs running inside the shared examples [mdv]

RSpec.describe Ability, type: :model do

  describe "Project Submitter" do

    let(:user) { build_stubbed(:user) }
    subject(:ability) { Ability.new(user) }

    let(:old_project) { build_stubbed(:project, submitter: user) }
    let(:other_project) { build_stubbed(:project, submitter: other_user) }
    let(:same_season_project) { build :project, :in_current_season, submitter: user }
    let(:other_user) { build_stubbed(:user) }

    it_behaves_like "same public features as confirmed user"
    it { expect(subject).to be_able_to([:update, :destroy], Project.new(submitter: user)) }
    it { expect(subject).to be_able_to(:use_as_template, old_project) }
    it { expect(subject).not_to be_able_to(:use_as_template, other_project) }
    it { expect(subject).not_to be_able_to :use_as_template, same_season_project }
  end
end
