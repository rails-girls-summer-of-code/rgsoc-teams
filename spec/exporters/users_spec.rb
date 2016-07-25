require 'spec_helper'

RSpec.describe Exporters::Users do

  describe '#current_students' do
    let(:old_team) { create :team, season: nil }
    let(:new_team) { create :team, :in_current_season }

    let!(:old_student) { create :user, name: "OLDSTUDENT" }
    let!(:new_student) { create :user, name: "NEWSTUDENT" }

    before do
      create :student_role, user: old_student, team: old_team
      create :student_role, user: new_student, team: new_team
    end

    it 'exports all projects of the current season' do
      expect(described_class.current_students).to match 'NEWSTUDENT'
      expect(described_class.current_students).not_to match 'OLDSTUDENT'
    end
  end

end
