# frozen_string_literal: true

class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_or_create_for_github_oauth(request.env['omniauth.auth'])
    flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'GitHub'
    sign_in_and_redirect user, event: :authentication
  end

  def after_sign_in_path_for(user)
    if user.confirmed?
      request.env['omniauth.origin'] || root_path
    else
      edit_user_path(user, welcome: true)
    end
  end
end
