require 'rails_helper'

RSpec.describe Exporters::Applications do
  let(:old_season)        { create :season, name: "2015" }
  let(:selected_team)     { create :team,   kind: 'full_time' }
  let(:not_selected_team) { create :team,   kind: nil }

  let!(:selected_application) do
    application = create :application, season: old_season, team: selected_team
    application.application_data["student0_application_coding_level"] = "OLDTEAM_SELECTED"
    application.application_data["student0_application_coding_level"] = "OLDTEAM_SELECTED"
    application.save
    application
  end

  let!(:not_selected_application) do
    application = create :application, season: old_season, team: not_selected_team
    application.application_data["student0_application_coding_level"] = "OLDTEAM_NOT_SELECTED"
    application.application_data["student0_application_coding_level"] = "OLDTEAM_NOT_SELECTED"
    application.save
    application
  end

  let!(:new_application) { create :application, :in_current_season }

  describe '#current' do
    subject { described_class.current }

    it 'exports all applications of the current season' do
      csv_rows = subject.split("\n")
      expect(csv_rows.size).to eql 2
      expect(csv_rows.last).to start_with new_application.team_id.to_s
    end
  end

  describe '#application_<year>' do
    it 'exports all applications of the given season' do
      export_method = "applications_#{old_season.year}"
      expect(described_class.send export_method).to match "OLDTEAM_SELECTED"
      expect(described_class.send export_method).to match "OLDTEAM_NOT_SELECTED"
    end

    it 'will raise an exception when trying to export a nonexistent season' do
      export_method = "applications_1970"
      expect { described_class.send export_method }.to raise_error NoMethodError
    end
  end

  describe '#accepted_application_<year>' do
    it 'exports all applications of the given season' do
      export_method = "accepted_applications_#{old_season.year}"
      expect(described_class.send export_method).to match "OLDTEAM_SELECTED"
      expect(described_class.send export_method).not_to match "OLDTEAM_NOT_SELECTED"
    end

    it 'will raise an exception when trying to export a nonexistent season' do
      export_method = "accepted_applications_1970"
      expect { described_class.send export_method }.to raise_error NoMethodError
    end
  end
end
