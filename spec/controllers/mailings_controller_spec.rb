require 'spec_helper'

describe MailingsController do
  render_views

  let(:mailing)        { FactoryGirl.create(:mailing) }
  let(:user)           { FactoryGirl.create(:user) }
  let(:valid_session)  { { "warden.user.user.key" => session["warden.user.user.key"] } }

  shared_context 'User logged in' do
    before { sign_in user }
  end

  describe 'GET index' do
    before { mailing }

    context 'with user logged in' do
      include_context 'User logged in'

      it 'renders the index template' do
        get :index, {}, valid_session
        expect(response).to render_template 'index'
      end
    end

    context 'as guest user' do
      it 'denies access' do
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to match 'not authorized'
      end
    end
  end

  describe 'GET show' do
    context 'with user logged in' do
      include_context 'User logged in'

      it 'renders the show template' do
        get :show, { id: mailing.to_param }, valid_session
        expect(response).to render_template 'show'
      end
    end

    context 'as guest user' do
      it 'denies access' do
        get :show, { id: mailing.to_param }
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to match 'not authorized'
      end
    end
  end

end
