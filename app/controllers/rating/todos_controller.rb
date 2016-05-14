class Rating::TodosController < Rating::BaseController
  respond_to :html

  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Todo', [:rating, :todos] ]
  end

  def index
    @applications = Application.includes(:ratings, :team).
      where(season: current_season)
  end
end
