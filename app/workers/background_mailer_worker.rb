class BackgroundMailerWorker
  include SuckerPunch::Job

  def perform(mailer)
    mailer.deliver
  end
end
