require 'spec_helper'

RSpec.describe ApplicationDraftsController do
  render_views

  let(:team) { create :team }

  before do
    Timecop.travel(Time.utc(2013, 3, 15))
  end

  context 'as an anonymous user' do
    describe 'GET new' do
      it 'renders the "sign_in" template' do
        get :new
        expect(response).to render_template 'sign_in'
      end
    end
  end

  context 'as an authenticated user' do
    let(:user) { create(:user) }

    before do
      allow(controller).to receive_messages(signed_in?: true)
      allow(controller).to receive_messages(current_user: user)
    end

    describe 'GET new' do
      it 'redirects if not part of a students team' do
        get :new
        expect(response).to redirect_to new_team_path
        expect(flash[:alert]).to be_present
      end

      it 'renders the "new" template for a single team member' do
        create :student_role, user: user
        get :new
        expect(response).to render_template 'new'
        expect(response.body).to \
          match "You haven't got a second student on your team."
      end

      it 'renders the "new" template for a tean with two students' do
        other_role = create :student_role
        create :student_role, user: user, team: other_role.team
        get :new
        expect(response).to render_template 'new'
      end

      it 'redirects to edit if draft is already persisted' do
        create :student_role, user: user
        draft = user.teams.last.application_drafts.create

        get :new
        expect(response).to redirect_to [:edit, draft]
      end
    end

    describe 'GET edit' do
      let(:draft) { create :application_draft }

      it 'redirects if not part of a team' do
        get :edit, id: draft.to_param
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end

      it 'will not find somebody else\'s draft' do
        create :student_role, user: user
        expect {
          get :edit, id: draft.to_param
        }.to raise_error ActiveRecord::RecordNotFound
      end
    end

  end
end
