class ApplicationsController < ApplicationController
  before_filter :checktime
  before_action :authenticate_user!, except: :new
  respond_to :html

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

  private

  def application_form
    @application_form ||= ApplicationForm.new(application_form_params)
  end

  def application_params
    {
      name: application_form.student_name,
      email: application_form.student_email,
      application_data: application_form.serializable_hash
    }
  end

  def application_form_params
    params.require(:application).permit(*ApplicationForm::FIELDS)
  end

  def checktime
    if Time.now.utc >= Time.utc(2014, 5, 2, 23, 59)
      render :ended
    end
  end
end
