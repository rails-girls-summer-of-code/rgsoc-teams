class ApplicationFormMailerWorker
  include SuckerPunch::Job


  def logger
    Rails.logger
  end

  def perform(payload)
    application =  Application.find(payload[:application_id])
    logger.info "sending Application: #{application.id}"
    ApplicationFormMailer.new_application(application).deliver
  end
end
