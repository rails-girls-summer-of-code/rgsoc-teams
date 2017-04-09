require 'spec_helper'

describe Rating::TodosController, type: :controller do
  render_views

  describe 'GET index' do
    it 'requires login' do
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in FactoryGirl.create(:organizer)
      get :index
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user)  { FactoryGirl.create :reviewer }
      let(:todos) { FactoryGirl.build_list(:todo, 10, user: user) }

      before do
        sign_in user
        allow(controller.current_user.todos)
          .to receive(:for_current_season)
          .and_return(todos)
        get :index
      end

      it 'assigns the users @todos' do
        expect(assigns :todos).to match_array todos
      end

      it 'renders :index' do
        expect(response).to render_template 'rating/todos/index'
      end
    end
  end
end
