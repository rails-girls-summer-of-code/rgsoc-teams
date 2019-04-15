require 'rails_helper'

RSpec.describe 'The Application Process', type: :request do
  describe 'GET /apply' do
    context 'with student logged in' do
      let!(:user) { create :student }

      before { sign_in user }

      context 'during the application phase' do
        let(:time) { Season.current.applications_open_at + 1.day }

        before { Timecop.travel(time) }

        after { Timecop.return }

        context 'as part of a team' do
          let!(:team) { user.teams.last }
          before { create :student_role, team: team }

          context 'when the user profile is invalid' do
            before { user.update_attribute :email, nil }

            it 'complains about the user data being incomplete' do
              get '/apply'
              expect(response).to have_http_status(:success)
              expect(response.body).to include 'Your user profile is incomplete'
            end
          end
        end
      end
    end
  end
end
