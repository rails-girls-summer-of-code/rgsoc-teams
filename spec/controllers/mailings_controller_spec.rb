require 'spec_helper'

describe MailingsController do
  render_views

  let(:mailing)        { FactoryGirl.create(:mailing) }
  let(:user)           { FactoryGirl.create(:user) }

  describe 'GET index' do
    before { mailing }

    context 'with user logged in' do
      # include_context 'with user logged in' # => red
      before { sign_in user }                 # => green

      it 'renders the index' do
        get :index
        expect(response).to render_template 'index'
      end
    end

    context 'as guest user' do
      it 'denies access' do
        get :index
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to match /not authorized/
      end
    end
  end

  describe 'GET show' do

    context 'with student user logged in' do
      include_context 'with student logged in'

      it 'renders the show template for student recipient' do
        mailing.update(to: %w(students))
        get :show, params: { id: mailing.to_param }
        expect(response).to render_template 'show'
      end
    end
  end
end
