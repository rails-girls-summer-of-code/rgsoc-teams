# frozen_string_literal: true
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_or_create_for_github_oauth(request.env['omniauth.auth'])
    flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github'
    sign_in_and_redirect user, event: :authentication
  end
end
