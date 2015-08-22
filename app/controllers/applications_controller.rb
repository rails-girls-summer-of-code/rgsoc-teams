class ApplicationsController < ApplicationController
  include ApplicationsHelper

  before_action :store_filters, only: :index
  before_action :persist_order, only: :index
  before_action :authenticate_user!, except: :new
  before_action -> { require_role 'reviewer' }
  respond_to :html

  def index
    @applications = applications_table
  end

  def edit
    @application = Application.find(params[:id])
  end

  def update
    @application = Application.find(params[:id])
    #if button value = save do this, if button value = final check set state: final
    #BUT there is an :update in application_drafts_controller as well

    if @application.update_attributes(application_params)
      redirect_to action: :index
    else
      render :edit
    end
  end

  def show
    @application = Application.find(params[:id])
    @application_data = @application.data_for(:application, @application)
    @rating = find_or_initialize_rating
    @data = RatingData.new(@rating.data)
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
    Rating.where(user: current_user, rateable: @application).first_or_initialize do |rating|
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

end
