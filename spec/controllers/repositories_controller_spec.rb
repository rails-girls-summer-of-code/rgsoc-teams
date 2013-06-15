require 'spec_helper'

describe RepositoriesController do

  let(:valid_attributes) { build(:repository).attributes }
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all repositories as @repositories" do
      repository = create(:repository)
      get :index, { team_id: repository.team.to_param }, valid_session
      assigns(:repositories).should eq([repository])
    end
  end

  describe "GET show" do
    it "assigns the requested repository as @repository" do
      repository = create(:repository)
      get :show, { team_id: repository.team.to_param, id: repository.to_param }, valid_session
      assigns(:repository).should eq(repository)
    end
  end

  describe "GET new" do
    it "assigns a new repository as @repository" do
      team = create(:team)
      get :new, { team_id: team.to_param }, valid_session
      assigns(:repository).should be_a_new(Repository)
    end
  end

  describe "GET edit" do
    it "assigns the requested repository as @repository" do
      repository = create(:repository)
      get :edit, { team_id: repository.team.to_param, id: repository.to_param }, valid_session
      assigns(:repository).should eq(repository)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new Repository" do
        team = create(:team)
        expect {
          post :create, { team_id: team.to_param, repository: valid_attributes }, valid_session
        }.to change(Repository, :count).by(1)
      end

      it "assigns a newly created repository as @repository" do
        team = create(:team)
        post :create, { team_id: team.to_param, repository: valid_attributes }, valid_session
        assigns(:repository).should be_a(Repository)
        assigns(:repository).should be_persisted
      end

      it "redirects to the created repository" do
        team = create(:team)
        post :create, { team_id: team.to_param, repository: valid_attributes }, valid_session
        response.should redirect_to(assigns(:team))
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved repository as @repository" do
        team = create(:team)
        Repository.any_instance.stub(:save).and_return(false)
        post :create, { team_id: team.to_param, repository: { 'url' => 'invalid value' } }, valid_session
        assigns(:repository).should be_a_new(Repository)
      end

      it "re-renders the 'new' template" do
        team = create(:team)
        Repository.any_instance.stub(:save).and_return(false)
        post :create, { team_id: team.to_param, repository: { 'url' => 'invalid value' } }, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested repository" do
        repository = create(:repository)
        Repository.any_instance.should_receive(:update_attributes).with({ 'url' => 'xxx' })
        put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'xxx' } }, valid_session
      end

      it "assigns the requested repository as @repository" do
        repository = create(:repository)
        put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: valid_attributes }, valid_session
        assigns(:repository).should eq(repository)
      end

      it "redirects to the repository" do
        repository = create(:repository)
        put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: valid_attributes }, valid_session
        response.should redirect_to(assigns(:team))
      end
    end

    describe "with invalid params" do
      it "assigns the repository as @repository" do
        repository = create(:repository)
        # Trigger the behavior that occurs when invalid params are submitted
        Repository.any_instance.stub(:save).and_return(false)
        put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'invalid value' } }, valid_session
        assigns(:repository).should eq(repository)
      end

      it "re-renders the 'edit' template" do
        repository = create(:repository)
        # Trigger the behavior that occurs when invalid params are submitted
        Repository.any_instance.stub(:save).and_return(false)
        put :update, { team_id: repository.team.to_param, id: repository.to_param, repository: { 'url' => 'invalid value' } }, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested repository" do
      repository = create(:repository)
      expect {
        delete :destroy, { team_id: repository.to_param, id: repository.to_param }, valid_session
      }.to change(Repository, :count).by(-1)
    end

    it "redirects to the repositories list" do
      repository = create(:repository)
      delete :destroy, { team_id: repository.to_param, id: repository.to_param }, valid_session
      response.should redirect_to(assigns(:team))
    end
  end

end
