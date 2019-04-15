# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ProjectsController, type: :request do
  describe 'GET /projects/:id/use_as_template' do
    let(:submitter) { create :user }
    let(:season)    { nil }
    let!(:project)  { create :project, season: season, submitter: submitter }

    shared_examples_for 'returns to the previous page' do
      it 'returns to the previous page' do
        get use_as_template_project_path(project), headers: { 'HTTP_REFERER' => '/previouspage' }
        expect(response).to redirect_to '/previouspage' # load_and_authorize_resource finds the referrer
        expect(flash[:alert]).to match %r{not authorized}
      end
    end

    context 'when the user is not logged in' do
      it_behaves_like 'returns to the previous page'
    end

    context 'when the user is logged in' do
      let(:user) { create :user }
      before { sign_in user }

      context 'when the user does not own the project' do
        it_behaves_like 'returns to the previous page'
      end

      context 'when the user has submitted the project before' do
        let(:submitter) { user }

        context 'when the project is from the current season' do
          let(:season) { Season.current }
          it_behaves_like 'returns to the previous page'
        end

        context 'when the project is from a past season' do
          let(:season) { Season.find_or_create_by!(name: '2013') }

          it 'returns to the previous page' do
            get use_as_template_project_path(project)
            expect(response).to have_http_status(:success)
            expect(response.body).to match project.name
          end
        end
      end
    end
  end
end
