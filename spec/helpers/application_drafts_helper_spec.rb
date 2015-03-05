require 'spec_helper'

RSpec.describe ApplicationDraftsHelper do

  describe '#may_edit?' do
    let(:student_role) { create :student_role }
    let(:student) { student_role.user }

    before do
      allow(self).to receive(:current_student).and_return(stranger)
    end

    context 'when not logged in' do
      let(:stranger) { build_stubbed(:user) }

      it 'returns false for nil' do
        expect(may_edit?(nil)).to be_falsey
      end

      it 'returns false if student is not persisted' do
        expect(may_edit?(Student.new)).to be_falsey
      end
    end

    context 'when logged in' do
      let(:stranger) { build_stubbed(:user) }

      it 'returns false for nil' do
        expect(may_edit?(nil)).to be_falsey
      end

      it 'returns false if student is not persisted' do
        expect(may_edit?(Student.new)).to be_falsey
      end

      context 'as a stranger' do
        it 'returns false' do
          expect(may_edit? student).to be_falsey
        end
      end

      context 'as another student from the team' do
        let(:stranger) { create(:student_role, team: student_role.team).user }

        it { expect(may_edit? student).to be_falsey }
      end

      context 'as a non-student from the team' do
        let(:stranger) { create(:coach_role, team: student_role.team).user }

        it { expect(may_edit? student).to be_falsey }
      end

      context 'as the student herself' do
        it 'returns true' do
          allow(self).to receive(:current_student).and_return(student)
          expect(may_edit? student).to be_truthy
        end
      end
    end
  end
end
