require 'spec_helper'

RSpec.describe TeamsHelper do

  describe "#conference_exists?" do
    let(:conference_preference) { FactoryGirl.create :conference_preference, :with_terms_checked }
    let(:team_without) { FactoryGirl.create :team }
    let(:team_with) { conference_preference.team }

    it 'should return false if don\'t exists conference persisted' do
      expect(conference_exists_for(team_without)).to be false
    end

    it 'should return true if exists any conference persisted' do
      expect(conference_exists_for(team_with)).to be true
    end
  end
end