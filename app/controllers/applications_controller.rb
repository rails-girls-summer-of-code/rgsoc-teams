require 'applications/table'

class ApplicationsController < ApplicationController
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
    end
  end

  def show
    @application = Application.find(params[:id])
    @rating = find_or_initialize_rating
    @data = RatingData.new(@rating.data)
    @prev = prev_application
    @next = next_application
  end

  private

  def application_form
    @application_form ||= ApplicationForm.new(application_form_params)
  end

  def application_params
    if params[:application]
      params.require(:application).permit(:misc_info, :project_visibility, :project_name)
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
    @applications = Application.includes(:ratings).sort_by(order)
  end

  def applications_table
    Applications::Table.new(Rating.user_names, applications, exclude: exclude)
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
end
