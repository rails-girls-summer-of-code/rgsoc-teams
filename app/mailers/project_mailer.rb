# frozen_string_literal: true

class ProjectMailer < ActionMailer::Base
  default from: ENV['EMAIL_FROM'] || 'contact@rgsoc.org'
  default_url_options[:protocol] = 'https'

  def proposal(project)
    subject = "[RGSoC] New Project Proposal!"
    @project = project
    mail subject: subject, to: 'contact@rgsoc.org'
  end

  def comment(project, comment)
    subject = "[RGSoC] New comment: Project '#{project.name}'"
    @project = project
    @comment = comment
    rcpts = (project.subscribers - [comment.user]).map(&:email)
    mail subject: subject, to: rcpts
  end
end
