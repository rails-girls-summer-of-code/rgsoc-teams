require 'spec_helper'

RSpec.describe Exporters::Applications do

  describe '#current' do
    subject { described_class.current }

    it 'returns empty export data' do
      expected = "Team ID;Coaching Company;Misc. Info;City;Country;Project Visibility;Remote Team;Mentor Pick;Volunteering Team;Selected;Male Gender;Zero Community;Age Below 18;Less Than Two Coaches\n"
      expect(subject).to eql expected
    end

    context 'for existing applications' do
      let!(:old_application) { create :application }
      let!(:new_application) { create :application, :in_current_season }

      it 'exports all applications of the current season' do
        csv_rows = subject.split("\n")
        expect(csv_rows.size).to eql 2
        expect(csv_rows.last).to start_with new_application.team_id.to_s
      end
    end
  end

end
