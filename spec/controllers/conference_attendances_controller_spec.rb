require 'spec_helper'

RSpec.describe ConferenceAttendancesController do
  let(:team) { FactoryGirl.create(:team, :in_current_season) }
  let(:student) { FactoryGirl.create(:student, team: team)}
  let(:attendance) { FactoryGirl.create(:conference_attendance, team: team )}
  
  before do
    sign_in student
  end

  describe 'PUT update' do
    it "cannot update other team's attendance" do
      other_attendance = create :conference_attendance
      expect {
        put :update, params: { id: other_attendance.id, attendance: true }
      }.to raise_error ActiveRecord::RecordNotFound
      expect(attendance.attendance).to be_falsy
    end

    it "can update her team's attendances" do
      put :update, params: { id: attendance.id, attendance: true, team_id: team.id }
      expect(attendance.reload.attendance).to be_truthy  
    end
  end
end
