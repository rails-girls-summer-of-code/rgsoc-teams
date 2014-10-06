class FormApplicationsController < ApplicationController
  include ApplicationsHelper

  #before_filter :checktime, only: [:new, :create]
  respond_to :html

  def index
    if signed_in?
      @form_application  = FormApplication.new(name: current_user.name, email: current_user.email)

    else
      render 'applications/sign_in'
    end
  end

  def show
  end

  def new
    if signed_in?
      @form_application  = FormApplication.new(name: current_user.name, email: current_user.email)

    else
      render 'applications/sign_in'
    end
  end

  def create
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

  def edit
    render :new
  end

  def update
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

  def submit
    if @form_application.valid?
      @application = current_user.applications.create!(form_application_params)
      ApplicationFormMailerWorker.new.async.perform(application_id: @application.id)
      @application
    else
      render :new
    end
  end

  private

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
end
