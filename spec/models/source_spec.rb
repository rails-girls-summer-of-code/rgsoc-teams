require 'spec_helper'

describe Source do
  it { is_expected.to belong_to(:team) }
  it { is_expected.to validate_presence_of(:url) }

  describe '.accepted' do
    let!(:accepted_team)   { create :team, kind: %w(sponsored voluntary).sample }
    let!(:accepted_source) { create :source, team: accepted_team }

    let!(:unaccepted_team)   { create :team, kind: nil }
    let!(:unaccepted_source) { create :source, team: unaccepted_team }

    it 'only returns blogs of accepted teams' do
      expect(described_class.accepted).to match_array [accepted_source]
    end
  end
end
