require 'rails_helper'

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

    it 'exports all students of the current season' do
      expect(described_class.current_students).to match 'NEWSTUDENT'
      expect(described_class.current_students).not_to match 'OLDSTUDENT'
    end

    context 'with alumni' do
      before do
        create :supervisor_role, user: old_student, team: new_team
      end

      it 'excludes users who have been a student before but are now otherwise involved' do
        expect(described_class.current_students).to match 'NEWSTUDENT'
        expect(described_class.current_students).not_to match 'OLDSTUDENT'
      end
    end
  end

  describe '#students_<year>' do
    let(:old_season) { create :season, name: "2015" }

    let(:old_team) { create :team, season: old_season }
    let(:new_team) { create :team, :in_current_season }

    let!(:old_student) { create :user, name: "OLDSTUDENT" }
    let!(:new_student) { create :user, name: "NEWSTUDENT" }

    before do
      create :student_role, user: old_student, team: old_team
      create :student_role, user: new_student, team: new_team
    end

    it 'exports all students of the given season' do
      export_method = "students_#{old_season.year}"
      expect(described_class.send export_method).to match 'OLDSTUDENT'
      expect(described_class.send export_method).not_to match 'NEWSTUDENT'
    end

    # This was a bug and checks that this will not
    # occur again :)
    it 'should still work when called twice' do
      export_method = "students_#{old_season.year}"
      expect(described_class.send export_method).to match 'OLDSTUDENT'
      expect(described_class.send export_method).to match 'OLDSTUDENT'
    end

    it 'will raise an exception when trying to export a nonexistent season' do
      export_method = "students_1970"
      expect { described_class.send export_method }.to raise_error NoMethodError
    end
  end
end
