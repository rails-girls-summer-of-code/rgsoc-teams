require 'spec_helper'

describe OmniauthCallbacksController do
  before do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe 'POST github' do

    it 'creates a new user and redirects to the user edit page' do
      @request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
        uid: '123', provider: 'example',
        info: { name: 'Name', email: 'name@example.com' },
        extra: { raw_info: {
          avatar_url: 'http://example.com/avatar.png',
          location:   'Location',
          bio:        'example user',
          login:      'example_user'
        }}
      )
      expect {
        post :github, format: :json
      }.not_to change { ActionMailer::Base.deliveries.count }
      expect(response).to redirect_to(edit_user_path(User.last, welcome: true))
    end

    # If you add a team member using it's github handle, the
    # user is ceated, but will be empty. If that users then
    # registers, we need to show the edit page
    it 'fills a stubbed used and redirects to the user edit page' do
      user = User.new
      user.github_handle = 'example_user'
      user.github_import = true
      user.save!

      @request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
        uid: 123, provider: 'example',
        info: { name: 'Name', email: 'name@example.com' },
        extra: { raw_info: {
          avatar_url: 'http://example.com/avatar.png',
          location:   'Location',
          bio:        'example user',
          login:      'example_user'
        }}
      )
      expect {
        post :github, format: :json
      }.not_to change { ActionMailer::Base.deliveries.count }
      expect(response).to redirect_to(edit_user_path(User.last, welcome: true))
      expect(user.reload.avatar_url).to eql 'http://example.com/avatar.png'
    end

    # If a user cancels the welcome page and then later signs
    # in again, we want to show that user the edit page to
    # let her/him complete the registration
    it 'redirects to the edit page if the profile is not valid' do
      user = FactoryGirl.build(:user, country: nil)
      user.github_import = true
      user.save

      @request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
        uid: 123, provider: 'example',
        info: { name: 'Name', email: 'name@example.com' },
        extra: { raw_info: {
          avatar_url: 'http://example.com/avatar.png',
          location:   'Location',
          bio:        'example user',
          login:      'example_user'
        }}
      )
      expect {
        post :github, format: :json
      }.not_to change { ActionMailer::Base.deliveries.count }
      expect(response).to redirect_to(edit_user_path(User.last, welcome: true))
    end

    it 'signs in the user if everything is okay' do
      user = create :user
      @request.env["omniauth.auth"] = OmniAuth::AuthHash.new(
        uid: '123', provider: 'example',
        info: { name: 'Name', email: 'name@example.com' },
        extra: { raw_info: {
          avatar_url: 'http://example.com/avatar.png',
          location:   'Location',
          bio:        'example user',
          login:      user.github_handle
        }}
      )
      post :github, format: :json
      expect(response).to redirect_to(user_path(user))
    end

  end
end
