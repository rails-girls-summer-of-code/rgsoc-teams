require 'spec_helper'

RSpec.describe Exporters::ConferencePreferences do

  describe '#current' do
    before do
      team1 = double('team')
      team2 = double('team')
      allow(ConferencePreference).to receive(:current_teams).and_return([team1, team2])
    end

    it 'returns a CSV file with conference preferences data from current teams' do
      get orga_exports_path
      expect(described_class.current).to match 'NEWPROJECT'
    end
  end
end