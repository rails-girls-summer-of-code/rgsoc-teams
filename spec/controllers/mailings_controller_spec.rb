require 'rails_helper'

RSpec.describe MailingsController, type: :controller do
  render_views

  let!(:mailing) { create(:mailing) }

  describe 'GET index' do
    context 'with user logged in' do
      include_context 'with user logged in'

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

    context 'as guest user' do
      it 'denies access' do
        get :show, params: { id: mailing.to_param }
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to match /not authorized/
      end
    end
  end
end
