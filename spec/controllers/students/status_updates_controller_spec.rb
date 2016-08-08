require 'spec_helper'

RSpec.describe Students::StatusUpdatesController do
  render_views

  it_behaves_like 'redirects for non-users'

  context 'with student logged in' do
    include_context 'with student logged in'

    let(:team) { create :team, :in_current_season }

    let(:status_update) { create :status_update, team: team }

    describe 'GET index' do
      let!(:other_status_update) { create :status_update }

      before { status_update }

      it 'lists all the team\'s status updates' do
        get :index
        expect(response).to render_template 'index'
        expect(assigns(:status_updates)).to match_array [status_update]
      end
    end

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(assigns(:status_update)).to be_a_new Activity
        expect(assigns(:status_update).kind).to eql 'status_update'
        expect(response).to render_template 'index'
        expect(response).to render_template(partial: '_form')
      end
    end

    describe 'POST create' do
      let(:attributes) { attributes_for :status_update }

      it 'creates a new status update' do
        expect {
          post :create, activity: attributes
        }.to change { team.status_updates.count }.by 1
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to [:students, :status_updates]
      end

      it 'immediately marks the activity as published' do
        post :create, activity: attributes

        activity = team.status_updates.last
        expect(activity.published_at).to be_present
      end

      it 'fails to create status update and renders index' do
        expect {
          post :create, activity: { title: '' }
        }.not_to change { team.status_updates.count }
        expect(response).to render_template 'index'
      end
    end

    describe 'GET show' do
      it 'renders the show template' do
        get :show, id: status_update.to_param
        expect(assigns(:status_update)).to eql status_update
        expect(response).to render_template 'show'
      end

      it 'renders markdown' do
        status_update.update content: "I am **bold**"
        get :show, id: status_update.to_param
        expect(response.body).to have_tag('strong') { with_text "bold" }
      end
    end

    describe 'GET edit' do
      it 'renders the edit template' do
        get :edit, id: status_update.to_param
        expect(assigns(:status_update)).to eql status_update
        expect(response).to render_template 'edit'
      end
    end

    describe 'PATCH update' do
      it 'updates the record and redirects to index' do
        expect {
          patch :update, id: status_update.to_param, activity: { title: 'foobar' }
        }.to change { status_update.reload.title }
        expect(flash[:notice]).to be_present
        expect(response).to redirect_to [:students, :status_updates]
      end

      it 'fails to update record and renders edit' do
        patch :update, id: status_update.to_param, activity: { title: '' }
        expect(response).to render_template 'edit'
      end
    end

    describe 'DELETE destroy' do
      before { status_update }

      it 'destroys the record and redirects to index' do
        expect {
          delete :destroy, id: status_update.to_param
        }.to change { team.status_updates.count }.by(-1)
        expect(response).to redirect_to [:students, :status_updates]
      end
    end

  end

end
