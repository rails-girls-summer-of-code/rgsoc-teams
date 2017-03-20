require 'spec_helper'

describe SourcesController do

  let(:user)             { create(:user) }
  let(:team)             { create(:team) }
  let(:source)           { create(:source, team: team) }
  let(:valid_attributes) { build(:source, team: team).attributes }

  before :each do
    sign_in user
  end

  describe "GET index" do
    it "assigns all sources as @sources" do
      get :index, params: { team_id: source.team.to_param }
      expect(assigns(:sources)).to eq([source])
    end
  end

  describe "GET show" do
    it "assigns the requested source as @source" do
      get :show, params: { team_id: source.team.to_param, id: source.to_param }
      expect(assigns(:source)).to eq(source)
    end
  end

  describe "GET new" do
    let!(:role) { create(:role, name: 'student', team: team, user: user) }

    it "assigns a new source as @source" do
      get :new, params: { team_id: team.to_param }
      expect(assigns(:source)).to be_a_new(Source)
    end
  end

  describe "GET edit" do
    it "assigns the requested source as @source" do
      get :edit, params: { team_id: source.team.to_param, id: source.to_param }
      expect(assigns(:source)).to eq(source)
    end
  end

  describe "POST create" do
    describe "on their own team" do
      let!(:role) { create(:role, name: 'student', team: team, user: user) }

      describe "with valid params" do
        it "creates a new Source" do
          params = { team_id: team.to_param, source: valid_attributes }
          expect { post :create, params: params }.to change(Source, :count).by(1)
        end

        it "assigns a newly created source as @source" do
          post :create, params: { team_id: team.to_param, source: valid_attributes }
          expect(assigns(:source)).to be_a(Source)
          expect(assigns(:source)).to be_persisted
        end

        it "redirects to the created source" do
          post :create, params: { team_id: team.to_param, source: valid_attributes }
          expect(response).to redirect_to(assigns(:team))
        end
      end

      describe "with invalid params" do
        let(:invalid_params) { { team_id: team.id, source: { url: 'invalid value' } } }

        it "assigns a newly created but unsaved source as @source" do
          allow_any_instance_of(Source).to receive(:save).and_return(false)
          post :create, params: invalid_params
          expect(assigns(:source)).to be_a_new(Source)
        end

        it "re-renders the 'new' template" do
          allow_any_instance_of(Source).to receive(:save).and_return(false)
          post :create, params: invalid_params
          expect(response).to render_template("new")
        end
      end
    end

    describe "on someone else's team" do
      let(:source) { create(:source, team: create(:team)) }

      it "does not create a new Source" do
        params = { team_id: source.team.to_param, source: valid_attributes }
        expect { post :create, params: params }.to_not change(Source, :count)
      end

      it "redirects to the root_url" do
        post :create, params: { team_id: team.to_param, source: valid_attributes }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "PUT update" do
    describe "on their own team" do
      let!(:role) { create(:role, name: 'student', team: team, user: user) }

      describe "with valid params" do
        it "updates the requested source" do
          expect_any_instance_of(Source).to receive(:update_attributes).with(ActionController::Parameters.new({ 'url' => 'xxx' }).permit(:url))
          put :update, params: { team_id: source.team.to_param, id: source.to_param, source: { 'url' => 'xxx' } }
        end

        it "assigns the requested source as @source" do
          put :update, params: { team_id: source.team.to_param, id: source.to_param, source: valid_attributes }
          expect(assigns(:source)).to eq(source)
        end

        it "redirects to the source" do
          put :update, params: { team_id: source.team.to_param, id: source.to_param, source: valid_attributes }
          expect(response).to redirect_to(assigns(:team))
        end
      end

      describe "with invalid params" do
        it "assigns the source as @source" do
          allow_any_instance_of(Source).to receive(:save).and_return(false)
          put :update, params: { team_id: source.team.to_param, id: source.to_param, source: { 'url' => 'invalid value' } }
          expect(assigns(:source)).to eq(source)
        end

        it "re-renders the 'edit' template" do
          allow_any_instance_of(Source).to receive(:save).and_return(false)
          put :update, params: { team_id: source.team.to_param, id: source.to_param, source: { 'url' => 'invalid value' } }
          expect(response).to render_template("edit")
        end
      end
    end

    describe "on someone else's team" do
      it "does not does not update the source" do
        expect_any_instance_of(Source).not_to receive(:update_attributes)
        put :update, params: { team_id: source.team.to_param, id: source.to_param, source: { 'url' => 'xxx' } }
      end

      it "redirects to the root_url" do
        put :update, params: { team_id: source.team.to_param, id: source.to_param, source: { 'url' => 'xxx' } }
        expect(response).to redirect_to(root_url)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:params) { { team_id: team.to_param, id: source.to_param } }

    describe "on their own team" do
      let!(:role)   { create(:role, name: 'student', team: team, user: user) }

      it "destroys the requested source" do
        expect { delete :destroy, params: params }.to change(Source, :count).by(-1)
      end

      it "redirects to the sources list" do
        delete :destroy, params: params
        expect(response).to redirect_to(assigns(:team))
      end
    end

    describe "on someone else's team" do
      it "does not does not destroy the source" do
        expect { delete :destroy, params: params }.to_not change(Source, :count)
      end

      it "redirects to the root_url" do
        delete :destroy, params: params
        expect(response).to redirect_to(root_url)
      end
    end
  end
end
