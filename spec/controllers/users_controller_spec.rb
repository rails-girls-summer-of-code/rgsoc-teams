require 'spec_helper'

describe UsersController do

  let(:valid_attributes) { build(:user).attributes.except('github_id', 'avatar_url') }
  let(:valid_session) { {} }

  describe "GET index" do
    it "assigns all users as @users" do
      user = create(:user)
      get :index, {}, valid_session
      assigns(:users).should eq([user])
    end
  end

  describe "GET show" do
    it "assigns the requested user as @user" do
      user = create(:user)
      get :show, { id: user.to_param }, valid_session
      assigns(:user).should eq(user)
    end
  end

  describe "GET new" do
    it "assigns a new user as @user" do
      get :new, {}, valid_session
      assigns(:user).should be_a_new(User)
    end
  end

  describe "GET edit" do
    it "assigns the requested user as @user" do
      user = create(:user)
      get :edit, { id: user.to_param }, valid_session
      assigns(:user).should eq(user)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "creates a new User" do
        expect {
          post :create, { user: valid_attributes }, valid_session
        }.to change(User, :count).by(1)
      end

      it "assigns a newly created user as @user" do
        post :create, { user: valid_attributes }, valid_session
        assigns(:user).should be_a(User)
        assigns(:user).should be_persisted
      end

      it "redirects to the created user" do
        post :create, { user: valid_attributes }, valid_session
        response.should redirect_to(User.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved user as @user" do
        User.any_instance.stub(:save).and_return(false)
        post :create, { user: { 'github_id' => 'invalid value' } }, valid_session
        assigns(:user).should be_a_new(User)
      end

      it "re-renders the 'new' template" do
        User.any_instance.stub(:save).and_return(false)
        post :create, { user: { 'github_id' => 'invalid value' } }, valid_session
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    describe "with valid params" do
      it "updates the requested user" do
        user = create(:user)
        User.any_instance.should_receive(:update_attributes).with({ 'name' => 'Trung Le' })
        put :update, { id: user.to_param, user: { 'name' => 'Trung Le' } }, valid_session
      end

      it "assigns the requested user as @user" do
        user = create(:user)
        put :update, { id: user.to_param, user: valid_attributes }, valid_session
        assigns(:user).should eq(user)
      end

      it "redirects to the user" do
        user = create(:user)
        put :update, { id: user.to_param, user: valid_attributes }, valid_session
        response.should redirect_to(user)
      end
    end

    describe "with invalid params" do
      it "assigns the user as @user" do
        user = create(:user)
        User.any_instance.stub(:save).and_return(false)
        put :update, { id: user.to_param, user: { 'name' => 'invalid value' } }, valid_session
        assigns(:user).should eq(user)
      end

      it "re-renders the 'edit' template" do
        user = create(:user)
        User.any_instance.stub(:save).and_return(false)
        put :update, { id: user.to_param, user: { 'name' => 'invalid value' } }, valid_session
        response.should render_template("edit")
      end
    end
  end

  describe "DELETE destroy" do
    it "destroys the requested user" do
      user = create(:user)
      expect {
        delete :destroy, { id: user.to_param }, valid_session
      }.to change(User, :count).by(-1)
    end

    it "redirects to the users list" do
      user = create(:user)
      delete :destroy, { id: user.to_param }, valid_session
      response.should redirect_to(users_url)
    end
  end

end
