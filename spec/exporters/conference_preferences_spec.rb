require 'rails_helper'

RSpec.describe Exporters::ConferencePreferences do
  describe '#current' do
    it 'calls the current_teams scope in conference preference' do
      expect(ConferencePreference).to receive(:current_teams).and_return([])
      described_class.current
    end
  end
end
