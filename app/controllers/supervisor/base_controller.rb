class Supervisor::BaseController < ApplicationController

  before_action :must_be_supervisor

  protected

  def must_be_supervisor
    unless signed_in? && current_user.roles.includes?('supervisor')
      redirect_to root_path, alert: 'Sorry, dashboard is for supervisors only'
    end
  end

  def supervisee_teams
    supervisee_teams = current_user.teams
  end

end
