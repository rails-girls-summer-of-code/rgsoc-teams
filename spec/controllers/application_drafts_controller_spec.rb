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

      it 'renders the "new" template' do
        create :student_role, user: user
        get :new
        expect(response).to render_template 'new'
      end

      it 'redirects to edit if draft is already persisted' do
        create :student_role, user: user
        draft = user.teams.last.application_drafts.create

        get :new
        expect(response).to redirect_to draft
      end

    end


  end
end
