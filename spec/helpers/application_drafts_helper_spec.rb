require 'rails_helper'

RSpec.describe ApplicationDraftsHelper, type: :helper do
  describe '#may_edit?' do
    let(:student_role) { create :student_role }
    let(:student) { student_role.user }
    let(:stranger) { build_stubbed(:user) }
    let(:application_draft) { double.as_null_object }

    before do
      allow(self).to receive(:current_student).and_return(stranger)
      allow(self).to receive(:application_draft).and_return(application_draft)
    end

    context 'when not logged in' do
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
        before do
          allow(self).to receive(:current_student).and_return(student)
        end

        it 'returns true' do
          expect(may_edit? student).to be_truthy
        end

        context 'when the draft has been submitted' do
          let(:application_draft) { create(:application_draft, :appliable) }

          before { application_draft.submit_application(1.hour.ago) }

          it 'returns false' do
            expect(may_edit? student).to be_falsey
          end
        end
      end
    end
  end
end
