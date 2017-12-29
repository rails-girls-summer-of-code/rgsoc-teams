# frozen_string_literal: true
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  after_action :store_location

  helper_method :current_season, :current_student

  before_action do
    redirect_to = params[:redirect_to]
    redirect_to ||= request.env['omniauth.params']['redirect_to'] if request.env['omniauth.params']
    session[:redirect_to] = redirect_to if redirect_to.present?
  end

  # workaround fix for cancan on rails4 - https://github.com/ryanb/cancan/issues/835
  before_action do
    resource = controller_path.singularize.gsub('/', '_').to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end

  before_action :set_timezone

  # Allow users to impersonate other uses in a non-production environment.
  # See the `pretender` gem.
  impersonates :user

  def after_sign_in_path_for(user)
    if user.just_created?
      request.env['omniauth.origin'] || edit_user_path(user, welcome: true)
    else
      request.env['omniauth.origin'] || session.delete(:previous_url_login_required) || session.delete(:previous_url) || user_path(current_user)
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  def cors_preflight
    if request.method == :options
      headers['Access-Control-Allow-Origin'] = '*'
      headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
      headers['Access-Control-Allow-Headers'] = 'X-Requested-With, X-Prototype-Version'
      headers['Access-Control-Max-Age'] = '1728000'
      render text: '', content_type: 'text/plain'
    end
  end

  def cors_set_headers
    headers['Access-Control-Allow-Origin'] = '*'
    headers['Access-Control-Allow-Methods'] = 'POST, GET, OPTIONS'
    headers['Access-Control-Max-Age'] = "1728000"
  end

  def current_season
    @season ||= Season.current
  end

  def current_student
    return unless current_user
    @current_student ||= Student.new(current_user)
  end

  def require_role(role_name)
    redirect_to '/', alert: "#{role_name.capitalize} required" unless current_user && current_user.roles.includes?(role_name)
  end

  def login_required
    store_location key: :previous_url_login_required
    redirect_to root_path, alert: 'Please log in with your Github account first' unless current_user
  end

  def store_location(key: :previous_url)
    return unless request.get?
    if !request.path.starts_with?('/auth') && \
        request.path != "/sign_out" && \
        !request.xhr? # don't store ajax calls
      session[key] = request.fullpath
    end
  end

  def set_timezone
    begin
      Time.zone = current_user&.timezone
    rescue ArgumentError
      Time.zone = 'UTC'
    end
  end

  # we are using devise with OmniAuth without other authentications, so we need to define this ourselfes
  # https://github.com/plataformatec/devise/wiki/OmniAuth%3A-Overview#using-omniauth-without-other-authentications
  def new_session_path(scope)
    root_path
  end

  # Sentry config
  before_action :set_raven_context

  private

  def set_raven_context
    if current_user
      Raven.user_context(id: current_user.id, username: current_user.github_handle)
    end
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
