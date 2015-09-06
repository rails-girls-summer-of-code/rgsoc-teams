class Supervisor::BaseController < ApplicationController

  before_action :must_be_supervisor
  helper_method :supervised_teams

  protected

  def must_be_supervisor
    unless signed_in? && current_user.roles.includes?('supervisor')
      redirect_to root_path, alert: 'Sorry, dashboard is for supervisors only'
    end
  end

  def supervised_teams
    if current_user.teams.any?
      @supervised_teams = current_user.teams.where("roles.name = 'supervisor'")
    else
      redirect_to supervisor_dashboard_path , alert: 'O no! No teams for you to supervise.'
    end
  end

end
