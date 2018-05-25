# frozen_string_literal: true
class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    user = User.find_or_create_for_github_oauth(request.env['omniauth.auth'])


    # if user.just_created? || !user.valid? || user.github_import || !user.confirmed? || user.email.nil? || user.github_id.nil?
    # They ^ have one thing in common: they can not be confirmed yet
    if !user.confirmed?
      sign_in user
      # flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github' # add this notice for clarity
      redirect_to edit_user_path(user, welcome: true)
    else
    # elsif user.persisted? # all users persists
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Github'
      sign_in_and_redirect user, event: :authentication
    # nothing else
      # else
    #   session['devise.github_data'] = request.env['omniauth.auth']
    #   redirect_to new_user_registration_url  # this route doesn't go anywhere (we don't use Devise registerable module)
    end
  end
end
