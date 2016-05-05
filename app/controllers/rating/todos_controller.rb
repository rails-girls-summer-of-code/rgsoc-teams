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

  def show
    @application = Application.includes(:team, :project, :comments).find(params[:id])
    @rating = @application.ratings.find_or_initialize_by(user: current_user)

    @breadcrumbs << ["Application ##{@application.id}", rating_todo_path(@application)]
  end

end
