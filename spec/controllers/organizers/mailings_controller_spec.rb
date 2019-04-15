require 'rails_helper'

RSpec.describe Organizers::MailingsController, type: :controller do
  render_views

  it_behaves_like 'redirects for non-admins'

  let(:mailing) { create(:mailing) }

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'index'
      end
    end

    describe 'GET show' do
      it 'shows a mailing' do
        get :show, params: { id: mailing.to_param }
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'show'
      end
    end

    describe 'GET edit' do
      it 'renders the edit template' do
        get :edit, params: { id: mailing.to_param }
        expect(response).to have_http_status(:success)
        expect(response).to render_template 'edit'
      end
    end
  end
end
