require 'spec_helper'

RSpec.describe Exporters::Applications do

  describe '#current' do
    subject { described_class.current }

    it 'returns empty export data' do
      expect(subject).to eql "Team ID\n"
    end

    context 'for existing applications' do
      let!(:old_application) { create :application }
      let!(:new_application) { create :application, :current }

      it 'exports all applications of the current season' do
        csv_rows = subject.split("\n")
        expect(csv_rows.size).to eql 2
        expect(csv_rows.last).to start_with new_application.team_id.to_s
      end
    end
  end

end
