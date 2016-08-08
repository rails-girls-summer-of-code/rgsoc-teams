require 'spec_helper'

RSpec.describe Exporters::Teams do

  describe '#current' do
    let!(:old_team) { create :team, name: "OLDTEAM" }
    let!(:new_team) { create :team, :in_current_season, name: "NEWTEAM" }
    let!(:app_team) { create :team, :applying_team, :in_current_season, name: "APPLYINGTEAM" }

    subject { described_class.current }

    it 'exports all teams of the current season' do
      expect(subject).to match 'NEWTEAM'
      expect(subject).to match 'APPLYINGTEAM'
      expect(subject).not_to match 'OLDTEAM'
    end
  end

end

