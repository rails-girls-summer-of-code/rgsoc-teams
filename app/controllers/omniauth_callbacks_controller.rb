class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_or_create_for_github_oauth(request.env['omniauth.auth'])

    if user.just_created? || !user.valid? || user.github_import
      sign_in user
      redirect_to edit_user_path(user, welcome: true)
    elsif user.persisted?
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github'
      sign_in_and_redirect user, event: :authentication
    else
      session['devise.github_data'] = request.env['omniauth.auth']
      redirect_to new_user_registration_url
    end
  end
end
