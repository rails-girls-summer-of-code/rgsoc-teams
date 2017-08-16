require 'spec_helper'

RSpec.describe Exporters::ConferencePreferences do

  describe '#current' do
    let!(:old_team) { create :team, :with_preferences, name: "OLDTEAM" }
    let!(:new_team) { create :team, :with_preferences, :in_current_season, name: "NEWTEAM" }

    subject { described_class.current }

    it 'exports conference preferences for teams of the current season' do
      expect(subject).to match 'NEWTEAM'
      expect(subject).not_to match 'OLDTEAM'
    end
  end
end