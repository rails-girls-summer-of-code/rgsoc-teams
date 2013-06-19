require 'spec_helper'

describe RepositoriesController do

  let(:user)             { create(:user) }
  let(:team)             { create(:team) }
  let(:repository)       { create(:repository, team: team) }
  let(:valid_attributes) { build(:repository, team: team).attributes }
  let(:valid_session)    { { "warden.user.user.key" => session["warden.user.user.key"] } }

  before :each do
    sign_in user
  end

  describe "GET index" do
    it "assigns all repositories as @repositories" do
      get :index, { team_id: repository.team.to_param }, valid_session
      assigns(:repositories).should eq([repository])
    end
  end

  describe "GET show" do
    it "assigns the requested repository as @repository" do
      get :show, { team_id: repository.team.to_param, id: repository.to_param }, valid_session
      assigns(:repository).should eq(repository)
    end
  end

  describe "GET new" do
    let!(:role) { create(:role, name: 'student', team: team, user: user) }

    it "assigns a new repository as @repository" do
      get :new, { team_id: team.to_param }, valid_session
      assigns(:repository).should be_a_new(Repository)
    end
  end

  describe "GET edit" do
    it "assigns the requested repository as @repository" do
      get :edit, { team_id: repository.team.to_param, id: repository.to_param }, valid_session
      assigns(:repository).should eq(repository)
    end
  end

  describe "POST create" do
    describe "on their own team" do
      let!(:role) { create(:role, name: 'student', team: team, user: user) }

      describe "with valid params" do
        it "creates a new Repository" do
          params = { team_id: team.to_param, repository: valid_attributes }
          expect { post :create, params, valid_session }.to change(Repository, :count).by(1)
        end

        it "assigns a newly created repository as @repository" do
          post :create, { team_id: team.to_param, repository: valid_attributes }, valid_session
          assigns(:repository).should be_a(Repository)
          assigns(:repository).should be_persisted
        end

        it "redirects to the created repository" do
          post :create, { team_id: team.to_param, repository: valid_attributes }, valid_session
          response.should redirect_to(assigns(:team))
        end
      end

      describe "with invalid params" do
        let(:invalid_params) { { team_id: team.id, repository: { url: 'invalid value' } } }

        it "assigns a newly created but unsaved repository as @repository" do
          Repository.any_instance.stub(:save).and_return(false)
          post :create, invalid_params, valid_session
          assigns(:repository).should be_a_new(Repository)
        end

        it "re-renders the 'new' template" do
          Repository.any_instance.stub(:save).and_return(false)
          post :create, invalid_params, valid_session
          response.should render_template("new")
        end
      end
    end

    describe "on someone else's team" do
      let(:repository) { create(:repository, team: create(:team)) }

      it "does not create a new Repository" do
        params = { team_id: repository.team.to_param, repository: valid_attributes }
        expect { post :create, params, valid_session }.to_not change(Repository, :count)
      end

      it "redirects to the root_url" do
        post :create, { team_id: team.to_param, repository: valid_attributes }, valid_session
        response.should redirect_to(root_url)
      end
    end
  end

  describe "PUT update" do
    describe "on their own team" do
      let!(:role) { create(:role, name: 'student', team: team, user: user) }

      describe "with valid params" do
        it "updates the requested repository" do
          Repository.any_instance.should_receive(:update_attributes).with({ 'url' => 'xxx' })
          put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'xxx' } }, valid_session
        end

        it "assigns the requested repository as @repository" do
          put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: valid_attributes }, valid_session
          assigns(:repository).should eq(repository)
        end

        it "redirects to the repository" do
          put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: valid_attributes }, valid_session
          response.should redirect_to(assigns(:team))
        end
      end

      describe "with invalid params" do
        it "assigns the repository as @repository" do
          Repository.any_instance.stub(:save).and_return(false)
          put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'invalid value' } }, valid_session
          assigns(:repository).should eq(repository)
        end

        it "re-renders the 'edit' template" do
          Repository.any_instance.stub(:save).and_return(false)
          put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'invalid value' } }, valid_session
          response.should render_template("edit")
        end
      end
    end

    describe "on someone else's team" do
      it "does not does not update the repository" do
        Repository.any_instance.should_not_receive(:update_attributes)
        put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'xxx' } }, valid_session
      end

      it "redirects to the root_url" do
        put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'xxx' } }, valid_session
        response.should redirect_to(root_url)
      end
    end
  end

  describe "DELETE destroy" do
    let!(:params) { { team_id: team.to_param, id: repository.to_param } }

    describe "on their own team" do
      let!(:role)   { create(:role, name: 'student', team: team, user: user) }

      it "destroys the requested repository" do
        expect { delete :destroy, params, valid_session }.to change(Repository, :count).by(-1)
      end

      it "redirects to the repositories list" do
        delete :destroy, params, valid_session
        response.should redirect_to(assigns(:team))
      end
    end

    describe "on someone else's team" do
      it "does not does not destroy the repository" do
        expect { delete :destroy, params, valid_session }.to_not change(Repository, :count)
      end

      it "redirects to the root_url" do
        delete :destroy, params, valid_session
        response.should redirect_to(root_url)
      end
    end
  end
end
