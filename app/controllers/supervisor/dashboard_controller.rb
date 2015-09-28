class Supervisor::DashboardController < Supervisor::BaseController
  before_action :order, only: :index

  def index
  end

  private

  def order
    params[:name] if params[:name]
  end

end
