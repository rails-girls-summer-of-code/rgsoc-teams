class Supervisor::DashboardController < Supervisor::BaseController
  def index
    #render text: "This is Visor.... SuperVisor"
  end

  def supervisee_teams
    @supervisee_teams = current_user.teams
  end
end
