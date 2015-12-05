class ProjectMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM'] || 'summer-of-code@railsgirls.com'
  default_url_options[:protocol] = 'https'

  def proposal(project)
    rcpts = User.with_role('organizer').pluck(:email)
    subject = "[RGSoC] New Project Proposal!"
    @project = project
    mail subject: subject, to: rcpts
  end

end
