class Rating::ApplicationsController < Rating::BaseController
  include ApplicationsHelper

  before_action :store_filters, only: :index
  before_action :persist_order, only: :index
  respond_to :html

  def index
    @applications = applications_table
  end

  def show
    @application = Application.find(params[:id])
    @rating = @application.ratings.find_or_initialize_by(user: current_user)
  end

  def edit
    @application = Application.find(params[:id])
  end

  def update
    @application = Application.find(params[:id])
    if @application.update(application_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  private

  def application_params
    params.require(:application).
      permit(:misc_info,
            :project_visibility,
            :project_name,
            :city,
            :country,
            :coaching_company,
            Application::FLAGS)
  end

  def store_filters
    Application::FLAGS.each do |key|
      key = :"hide_#{key}"
      session[key] = params[:filter][key] == 'true' if params[:filter] && params[:filter].key?(key)
    end
  end

  def order
    params[:order] || session[:order] || :id
  end
  helper_method :order

  def persist_order
    session[:order] = :mean if session[:order] == 'total_rating'
    session[:order] = params[:order] if params[:order]
  end

  def exclude
    (params[:exclude] || session[:exclude] || '').split(',').map(&:strip)
  end

  def applications
    Application.includes(:ratings).where(season: current_season)
  end

  def applications_table
    options = { order: order, exclude: exclude, hide_flags: [] }
    Application::FLAGS.each do |flag|
      options[:hide_flags] << flag.to_s if send(:"hide_#{flag}?")
    end
    Rating::Table.new(Rating.user_names, applications, options)
  end

  def prev_application
    all = applications
    all = all.reverse if [:mean, :median, :weighted, :truncated].include?(order)
    ix = all.index { |a| a.id == params[:id].to_i }
    all[ix - 1]
  end

  def next_application
    all = applications
    all = all.reverse if [:mean, :median, :weighted, :truncated].include?(order)
    ix = all.index { |a| a.id == params[:id].to_i }
    all[ix + 1]
  end
end
