class FormApplicationsController < ApplicationController
  include ApplicationsHelper

  before_filter :checktime, only: [:new, :create]
  before_action :set_application,  only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @form_applications = FormApplication.all
  end

  def new
    if signed_in?
      @form_application  = FormApplication.new
    else
      render 'applications/sign_in'
    end
  end

  def show

  end

  def create
    if params[:apply_off]
      @application = current_user.applications.create!(application_params)
      @form_application.update_attributes({submitted: true})
      ApplicationFormMailer.new_application(@application).deliver_later
      @application
      render 'applications/create'
    else
      @form_application = FormApplication.new(form_application_params)
      respond_to do |format|
        if @form_application.save
          format.html { redirect_to @form_application, notice: 'Application was successfully created.' }
          format.json { render action: :show, status: :created, location: @form_application }
        else
          format.html { render action: :new }
          format.json { render json: @form_application.errors, status: :unprocessable_entity }
        end
      end
    end
  end


  def edit
    if @form_application.submitted
      @form_application = FormApplication.find(params[:id])
      render 'submit_form'
    else
      render 'edit'
    end
  end

  def update
    if params[:apply_off]
      @application = current_user.applications.create!(application_params)
      @form_application.update_attributes({submitted: true})
      ApplicationFormMailer.new_application(@application).deliver_later
      @application
      render 'applications/create'
    else
      respond_to do |format|
        if @form_application.update_attributes(form_application_params)
          format.html { redirect_to @form_application, notice: 'Application was successfully updated.' }
          format.json { head :no_content }
        else
          format.html { render action: :edit }
          format.json { render json: @form_application.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    @form_application.destroy
    respond_to do |format|
      format.html { redirect_to form_applications_url }
      format.json { head :no_content }
    end
  end

  private

  def form_application
    @form_application ||= FormApplication.new(form_application_params)
  end

  def set_application
    @form_application = FormApplication.find(params[:id])
  end

  def checktime
    if Time.now.utc >= Time.utc(2014, 5, 2, 23, 59)
      render 'applications/ended'
    end
  end

  def application
    @application ||= Application.new
  end


  def form_application_params
    params.require(:form_application).permit(*FormApplication::FIELDS)
  end

  def application_params
    {
      name: form_application.name,
      email: form_application.email,
      application_data: form_application.serializable_hash
    }
  end

  def applications
    if params[:show_hidden]
      @applications = Application.hidden.includes(:ratings) #.sort_by(order)
    else
      @applications = Application.visible.includes(:ratings) #.sort_by(order)
    end
  end
end
