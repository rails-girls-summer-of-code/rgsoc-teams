class ApplicationController < ActionController::Base
  protect_from_forgery

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

  def after_sign_in_path_for(user)
    if user.just_created?
      edit_user_path(user, welcome: true, redirect_to: session.delete(:redirect_to))
    else
      session.delete(:redirect_to) || user_path(current_user)
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
    #TEMP solution to find the application form
    #@season ||= Season.current
    @season = Season.find(2)
  end

  def current_student
    @current_student ||= Student.new(current_user)
  end

  def require_role(role_name)
    redirect_to '/' unless current_user && current_user.roles.includes?(role_name)
  end
end
