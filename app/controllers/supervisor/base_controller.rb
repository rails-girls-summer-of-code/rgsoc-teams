class Supervisor::BaseController < ApplicationController

  before_action :must_be_supervisor

  protected

  def must_be_supervisor
    redirect_to root_path, alert: 'Sorry, dashboard is for supervisors only' unless signed_in? && current_user.roles
        .includes?('supervisor')
  end
end