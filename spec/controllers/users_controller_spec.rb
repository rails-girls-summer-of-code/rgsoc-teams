require 'spec_helper'
require 'cancan/matchers'

describe UsersController do

  let(:valid_attributes) { build(:user).attributes.except('github_id', 'avatar_url') }
  #let(:valid_session) { { "warden.user.user.key" => session["warden.user.user.key"] } }
  def valid_session
    { "warden.user.user.key" => session["warden.user.user.key"] }
  end

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

  describe "GET edit" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end

    context "its own profile" do
      it "assigns the requested user as @user" do
        get :edit, { id: user.to_param }, valid_session
        assigns(:user).should eq(user)
      end
    end

    context "another user's profile" do
      let(:another_user) { FactoryGirl.create(:user) }

      it "redirects to the homepage" do
        get :edit, { id: another_user.to_param }, valid_session
        response.should redirect_to(root_url)
      end
    end
  end

  describe "PUT update" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end

    context "its own profile" do
      describe "with valid params" do
        it "updates the requested user" do
          User.any_instance.should_receive(:update_attributes).with({ 'name' => 'Trung Le' })
          put :update, { id: user.to_param, user: { 'name' => 'Trung Le' } }, valid_session
        end

        it "assigns the requested user as @user" do
          put :update, { id: user.to_param, user: valid_attributes }, valid_session
          assigns(:user).should eq(user)
        end

        it "redirects to the user" do
          put :update, { id: user.to_param, user: valid_attributes }, valid_session
          response.should redirect_to(user)
        end
      end

      describe "with invalid params" do
        it "assigns the user as @user" do
          User.any_instance.stub(:save).and_return(false)
          put :update, { id: user.to_param, user: { 'name' => 'invalid value' } }, valid_session
          assigns(:user).should eq(user)
        end

        it "re-renders the 'edit' template" do
          User.any_instance.stub(:save).and_return(false)
          put :update, { id: user.to_param, user: { 'name' => 'invalid value' } }, valid_session
          response.should render_template("edit")
        end
      end

      context "another user's profile" do
        let(:another_user) { FactoryGirl.create(:user) }

        it "does not update the requested user" do
          User.any_instance.should_not_receive(:update_attributes)
          put :update, { id: another_user.to_param, user: { 'name' => 'Trung Le' } }, valid_session
        end

        it "redirects the user to the homepage" do
          put :update, { id: another_user.to_param, user: valid_attributes }, valid_session
          response.should redirect_to(root_url)
        end
      end
    end
  end

  describe "DELETE destroy" do
    let(:user) { FactoryGirl.create(:user) }
    before :each do
      sign_in user
    end

    context "its own profile" do
      it "destroys the requested user" do
        expect {
          delete :destroy, { id: user.to_param }, valid_session
        }.to change(User, :count).by(-1)
      end

      it "redirects to the users list" do
        delete :destroy, { id: user.to_param }, valid_session
        response.should redirect_to(users_url)
      end
    end

    context "another user's profile" do
      let(:another_user) { FactoryGirl.create(:user) }

      it "doesn't destroy the requested user" do
        expect {
          delete :destroy, { id: another_user.to_param }, valid_session
        }.to change(User, :count).by(1)
      end

      it "redirects to the homepage" do
        delete :destroy, { id: another_user.to_param }, valid_session
        response.should redirect_to(root_url)
      end
    end
  end

end
