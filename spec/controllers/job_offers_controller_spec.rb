require 'spec_helper'

describe JobOffersController do
  render_views

  let(:user)          { create(:user) }
  let(:student)       { create(:student) }
  let(:job_offer)     { create(:job_offer) }
  let(:valid_session) { { "warden.user.user.key" => session["warden.user.user.key"] } }

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
      before { job_offer }
      before { sign_in student }

      it 'renders the index template' do
        get :index, {}, valid_session
        expect(response).to render_template 'index'
      end
    end
  end

end
