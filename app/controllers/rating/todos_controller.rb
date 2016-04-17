class Rating::TodosController < Rating::BaseController
  respond_to :html

  def index
    @applications = Application.includes(:ratings, :team).
      where(season: current_season)
  end
end
