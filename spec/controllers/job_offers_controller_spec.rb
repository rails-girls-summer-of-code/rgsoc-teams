require 'spec_helper'

describe JobOffersController do
  render_views

  let(:user)          { create(:user) }
  let(:job_offer)     { create(:job_offer) }
  let(:valid_session) { { "warden.user.user.key" => session["warden.user.user.key"] } }

  shared_context 'Student logged in' do
    let(:student) { create(:student) }
    before { sign_in student }
  end

  describe 'GET index' do
    context 'as an anonymous user' do
      it 'denies access' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'as a registered user' do
      before { sign_in user }

      it 'denies access' do
        get :index, {}, valid_session
        expect(response).to redirect_to root_path
      end
    end

    context 'as a student' do
      include_context 'Student logged in'

      before { job_offer }

      it 'renders the index template' do
        get :index, {}, valid_session
        expect(response).to render_template 'index'
      end
    end
  end

  describe 'GET show' do
    context 'as a student' do
      include_context 'Student logged in'

      it 'renders the show template' do
        get :show, { id: job_offer.to_param }, valid_session
        expect(response).to render_template 'show'
      end
    end
  end

end
