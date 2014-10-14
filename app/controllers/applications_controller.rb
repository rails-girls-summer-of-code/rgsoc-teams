class ApplicationsController < ApplicationController
  include ApplicationsHelper

  before_filter :store_filters, only: :index
  before_filter :persist_order, only: :index
  #before_filter :checktime, only: [:new, :create]
  before_action :authenticate_user!, except: :new
  before_filter -> { require_role 'reviewer' }, except: [:new, :create]
  respond_to :html

  def index
    @applications = applications_table
  end

  def new
    if signed_in?
      @application_form = ApplicationForm.new(student_name: current_user.name, student_email: current_user.email)
    else
      render 'sign_in'
    end
  end

  def create
    if application_form.valid?
      @application = current_user.applications.create!(application_params)
      ApplicationFormMailerWorker.new.async.perform(application_id: @application.id)
      @application
    else
      render :new
    end
  end

  def edit
    @application = Application.find(params[:id])
  end

  def update
    @application = Application.find(params[:id])
    if @application.update_attributes(application_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    @application = Application.find(params[:id])
    @rating = find_or_initialize_rating
    @data = RatingData.new(@rating.data)
    unless @application.hidden
      @prev = prev_application
      @next = next_application
    end
  end

  private

  def store_filters
    [:bonus_points, :cs_students, :remote_teams, :in_teams, :duplicates].each do |key|
      key = :"hide_#{key}"
      session[key] = params[:filter][key] == 'true' if params[:filter] && params[:filter].key?(key)
    end
  end

  def application_form
    @application_form ||= ApplicationForm.new(application_form_params)
  end

  def application_params
    if params[:action] == 'update'
      params.require(:application).permit(:misc_info, :project_visibility,
                                          :project_name, :city, :country, :coaching_company, Application::FLAGS)
    else
      {
        name: application_form.student_name,
        email: application_form.student_email,
        application_data: application_form.serializable_hash
      }
    end
  end

  def application_form_params
    params.require(:application).permit(*ApplicationForm::FIELDS)
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
    if params[:show_hidden]
      @applications = Application.hidden.includes(:ratings) #.sort_by(order)
    else
      @applications = Application.visible.includes(:ratings) #.sort_by(order)
    end
  end

  def applications_table
    options = { order: order, exclude: exclude }
    flags = [:bonus_points, :cs_students, :remote_teams, :in_teams, :duplicates]
    options = flags.inject(options) do |options, flag|
      options.merge(flag => send(:"display_#{flag}?"))
    end
    Application::Table.new(Rating.user_names, applications, options)
  end

  def find_or_initialize_rating
    @application.ratings.find_or_initialize_by(user: current_user) do |rating|
      rating.data = Hashr.new(@application.rating_defaults)
    end
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

  def checktime
    if Time.now.utc >= Time.utc(2014, 5, 2, 23, 59)
      render :ended
    end
  end
end
