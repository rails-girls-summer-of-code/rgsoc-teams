require 'rails_helper'

RSpec.describe Reviewers::TodosController, type: :controller do
  render_views

  describe 'GET index' do
    it 'requires login' do
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user)  { create :reviewer }
      let(:todos) { build_list(:todo, 10, user: user) }

      before do
        sign_in user
        allow(controller.current_user)
          .to receive(:todos)
          .and_return(double(for_current_season: todos))
        get :index
      end

      it 'assigns the users @todos' do
        expect(assigns :todos).to match_array todos
      end

      it 'renders :index' do
        expect(response).to render_template 'reviewers/todos/index'
      end
    end
  end
end
