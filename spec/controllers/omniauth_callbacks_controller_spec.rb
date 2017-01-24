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
