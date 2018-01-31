require 'rails_helper'

RSpec.describe Source, type: :model do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to validate_presence_of(:url) }

  describe '.for_accepted_teams' do
    let!(:accepted_team)   { create :team, kind: %w(sponsored deprecated_voluntary).sample }
    let!(:accepted_source) { create :source, team: accepted_team }

    let!(:unaccepted_team)   { create :team, kind: nil }
    let!(:unaccepted_source) { create :source, team: unaccepted_team }

    it 'only returns blogs of accepted teams' do
      expect(described_class.for_accepted_teams).to match_array [accepted_source]
    end
  end
end
