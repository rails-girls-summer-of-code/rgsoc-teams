require 'rails_helper'

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

  describe '#accepted_<year>' do
    let(:old_season) { create :season, name: "2015" }

    let!(:old_team) { create :team, season: old_season, name: "OLDTEAM" }
    let!(:new_team) { create :team, :in_current_season, name: "NEWTEAM" }
    let!(:app_team) { create :team, :applying_team, name: "APPLYINGTEAM" }

    it 'exports all accepted teams of the given season' do
      export_method = "accepted_#{old_season.year}"
      expect(described_class.send export_method).to match 'OLDTEAM'
      expect(described_class.send export_method).not_to match 'NEWSTUDENT'
      expect(described_class.send export_method).not_to match 'APPLYINGTEAM'
    end

    # This was a bug and checks that this will not
    # occur again :)
    it 'should still work when called twice' do
      export_method = "accepted_#{old_season.year}"
      expect(described_class.send export_method).to match 'OLDTEAM'
      expect(described_class.send export_method).to match 'OLDTEAM'
    end

    it 'will raise an exception when trying to export a nonexistent season' do
      export_method = "accepted_1970"
      expect { described_class.send export_method }.to raise_error NoMethodError
    end
  end
end
