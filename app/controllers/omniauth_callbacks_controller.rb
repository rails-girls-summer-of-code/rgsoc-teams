class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_or_create_for_github_oauth(request.env['omniauth.auth'])

    if user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', :kind => 'Github'
      sign_in_and_redirect user, :event => :authentication
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
