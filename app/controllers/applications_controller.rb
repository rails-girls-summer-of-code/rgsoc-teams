class ApplicationsController < ApplicationController
  respond_to :html

  def new
    if signed_in?
      @application_form = ApplicationForm.new
    else
      render 'sign_in'
    end
  end

  def create
    if application_form.valid?
      @application = Application.create!(name: application_form.student_name, email: application_form.student_email, application_data: application_form.serializable_hash )
      ApplicationFormMailerWorker.new.async.perform(application_id: @application.id)
      @application
    else
      flash.now.alert = application_form.errors
      render :new
    end
  end

  private

  def application_form
    @application_form ||= ApplicationForm.new(application_params)
  end

  def application_params
    params.require(:application).permit(*ApplicationForm::FIELDS)
  end
end
