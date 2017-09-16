require 'spec_helper'

RSpec.describe ConferenceAttendancesController do
  let(:team) { FactoryGirl.create(:team, :in_current_season) }
  let(:student) { FactoryGirl.create(:student, team: team)}
  let(:attendance) { FactoryGirl.create(:conference_attendance, team: team )}

  before do
    sign_in student
  end

  describe 'PUT update' do
    it "can update her team's attendances" do
      put :update, params: { id: attendance.id, conference_attendance: { attendance: true }}
      expect(attendance.reload.attendance).to be_truthy
    end
  end
end
