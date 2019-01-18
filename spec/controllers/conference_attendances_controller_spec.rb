require 'rails_helper'

RSpec.describe ConferenceAttendancesController, type: :controller do
  let(:team) { create(:team, :in_current_season) }
  let(:student) { create(:student, team: team) }
  let(:attendance) { create(:conference_attendance, team: team) }

  before do
    sign_in student
  end

  describe 'PUT update' do
    it "can update her team's attendances" do
      put :update, params: { id: attendance.id, conference_attendance: { attendance: true } }
      expect(attendance.reload.attendance).to be_truthy
    end
  end
end
