require 'spec_helper'

RSpec.describe Rating::Todos::ApplicationsController do
  render_views

  let(:application) { create :application }

  describe 'GET show' do
    it 'requires login' do
      get :show, params: { id: application.to_param }
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :show, params: { id: application.to_param }
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user) { create :reviewer }

      before do
        sign_in user
        get :show, params: { id: application.to_param }
      end

      it 'finds and assigns @application by id param' do
        expect(assigns :application).to eql application
      end

      it 'renders the "show" template' do
        expect(response).to render_template 'rating/todos/applications/show'
      end
    end
  end
end
