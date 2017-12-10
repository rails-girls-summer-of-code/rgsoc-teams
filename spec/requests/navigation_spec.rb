require 'spec_helper'

RSpec.describe 'Navigation', type: :request do
  describe 'during summer' do
    before { Timecop.travel(Season.current.starts_at + 1.day) }
    after  { Timecop.return }

    shared_examples :user_nav_during_summer do
      it 'displays general and user specific links for the phase' do
        expect(response.body).to include activities_path
        expect(response.body).to include teams_path
        expect(response.body).to include conferences_path
        expect(response.body).to include projects_path
        expect(response.body).to include users_path
        expect(response.body).to include page_path(:help)
        expect(response.body).to include user_path(user)
        expect(response.body).to include sign_out_path
      end

      it 'does not display links to apply or submit a project' do
        expect(response.body).not_to include application_drafts_path
        expect(response.body).not_to include apply_path
        expect(response.body).not_to include new_project_path
      end
    end

    context 'for guest users' do
      before { get '/' }

      it 'displays sign in and phase specific links' do
        expect(response.body).to include activities_path
        expect(response.body).to include teams_path
        expect(response.body).to include conferences_path
        expect(response.body).to include projects_path
        expect(response.body).to include users_path
        expect(response.body).to include page_path(:help)
        expect(response.body).to include user_github_omniauth_authorize_path
      end

      it 'hides role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include orga_dashboard_path
        expect(response.body).not_to include reviewers_dashboard_path
        expect(response.body).not_to include supervisors_dashboard_path
        expect(response.body).not_to include students_status_updates_path
      end

      it 'does not display links from other phases' do
        expect(response.body).not_to include application_drafts_path
        expect(response.body).not_to include apply_path
        expect(response.body).not_to include new_project_path
      end
    end

    context 'for students' do
      let(:team) { create :team, :in_current_season, kind: 'sponsored' }
      let(:user) { create(:student_role, team: team).user }

      before do
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_summer

      it { expect(response.body).to include students_status_updates_path }

      it 'hides other role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include orga_dashboard_path
        expect(response.body).not_to include reviewers_dashboard_path
        expect(response.body).not_to include supervisors_dashboard_path
      end
    end

    context 'for supervisors' do
      let(:user) { create(:supervisor) }

      before do
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_summer

      it { expect(response.body).to include supervisors_dashboard_path }

      it 'hides other role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include orga_dashboard_path
        expect(response.body).not_to include reviewers_dashboard_path
        expect(response.body).not_to include students_status_updates_path
      end
    end

    context 'for supervisors with orga role' do
      let(:user) { create(:supervisor) }

      before do
        create(:organizer_role, user: user)
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_summer

      it 'displays relevant items for supervisors and orgas' do
        expect(response.body).to include supervisors_dashboard_path
        expect(response.body).to include orga_dashboard_path
      end

      it 'hides other role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include students_status_updates_path
        expect(response.body).not_to include reviewers_dashboard_path
      end
    end

    context 'for organizers with reviewer role' do
      let(:user) { create(:organizer) }

      before do
        create(:reviewer_role, user: user)
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_summer

      it 'displays relevant items for orga and rating' do
        expect(response.body).to include orga_dashboard_path
        expect(response.body).to include reviewers_dashboard_path
      end

      it 'hides other role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include students_status_updates_path
        expect(response.body).not_to include supervisors_dashboard_path
      end
    end

    context 'for project_maintainers' do
      let(:user) { create(:user) }

      before do
        create(:project, :accepted, submitter: user)
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_summer

      it { expect(response.body).to include mentors_applications_path }

      it 'hides other role specific links' do
        expect(response.body).not_to include supervisors_dashboard_path
        expect(response.body).not_to include orga_dashboard_path
        expect(response.body).not_to include reviewers_dashboard_path
        expect(response.body).not_to include students_status_updates_path
      end
    end
  end

  describe 'during application phase' do
    before { Timecop.travel(Season.current.applications_open_at + 1.day) }

    after { Timecop.return }

    shared_examples :user_nav_during_application_phase do
      it 'displays sign in and links relevant for the phase' do
        expect(response.body).to include activities_path
        expect(response.body).to include projects_path
        expect(response.body).to include apply_path
        expect(response.body).to include users_path
        expect(response.body).to include page_path(:help)
        expect(response.body).to include user_path(user)
        expect(response.body).to include sign_out_path
        expect(response.body).to include teams_path
      end

      it 'does not display links for other phases' do
        expect(response.body).not_to include application_drafts_path
        expect(response.body).not_to include new_project_path
        expect(response.body).not_to include conferences_path
      end
    end

    context 'for guest users' do
      before { get '/' }

      it 'displays sign in and links relevant for the phase' do
        expect(response.body).to include activities_path
        expect(response.body).to include apply_path
        expect(response.body).to include teams_path
        expect(response.body).to include users_path
        expect(response.body).to include projects_path
        expect(response.body).to include page_path(:help)
        expect(response.body).to include user_github_omniauth_authorize_path
      end

      it 'hides role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include orga_dashboard_path
        expect(response.body).not_to include reviewers_dashboard_path
        expect(response.body).not_to include supervisors_dashboard_path
        expect(response.body).not_to include students_status_updates_path
      end

      it 'does not display any links for other phases' do
        expect(response.body).not_to include conferences_path
        expect(response.body).not_to include new_project_path
      end
    end

    context 'for students' do
      let(:user) { create(:student) }

      before do
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_application_phase

      it 'hides other role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include orga_dashboard_path
        expect(response.body).not_to include reviewers_dashboard_path
        expect(response.body).not_to include supervisors_dashboard_path
        expect(response.body).not_to include students_status_updates_path
      end
    end

    context 'for supervisors with orga role' do
      let(:user) { create(:supervisor) }

      before do
        create(:organizer_role, user: user)
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_application_phase

      it 'displays relevant items for supervisors and orgas for the current phase' do
        expect(response.body).not_to include supervisors_dashboard_path
        expect(response.body).to include orga_dashboard_path
      end

      it 'hides other role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include students_status_updates_path
        expect(response.body).not_to include reviewers_dashboard_path
      end
    end

    context 'for organizers with reviewer role' do
      let(:user) { create(:organizer) }

      before do
        create(:reviewer_role, user: user)
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_application_phase

      it 'displays relevant items for orga and rating' do
        expect(response.body).to include orga_dashboard_path
        expect(response.body).to include reviewers_dashboard_path
      end

      it 'hides other role specific links' do
        expect(response.body).not_to include mentors_applications_path
        expect(response.body).not_to include students_status_updates_path
        expect(response.body).not_to include supervisors_dashboard_path
      end
    end

    context 'for project_maintainers' do
      let(:user) { create(:user) }

      before do
        create(:project, :accepted, submitter: user)
        sign_in user
        get '/'
      end

      include_examples :user_nav_during_application_phase

      it { expect(response.body).to include mentors_applications_path }

      it 'hides other role specific links' do
        expect(response.body).not_to include supervisors_dashboard_path
        expect(response.body).not_to include orga_dashboard_path
        expect(response.body).not_to include reviewers_dashboard_path
        expect(response.body).not_to include students_status_updates_path
      end
    end
  end
end
