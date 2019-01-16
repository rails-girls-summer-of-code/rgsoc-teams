require 'rails_helper'

RSpec.describe TeamsHelper, type: :helper do
  describe "#conference_exists?" do
    let(:conference_preference) { create :conference_preference }
    let(:team_without) { create :team }
    let(:team_with) { conference_preference.team }

    it 'returns false if no conference_preference was persisted for the team' do
      expect(conference_exists_for?(team_without)).to be false
    end

    it 'returns true if exists any conference persisted' do
      expect(conference_exists_for?(team_with)).to be true
    end
  end
end
