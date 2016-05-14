class Rating::Todos::ApplicationsController < Rating::BaseController
  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Todo', [:rating, :todos] ]
  end

  def show
    @application = Application.includes(:team, :project, :comments).find(params[:id])
    @rating = @application.ratings.find_or_initialize_by(user: current_user)

    @breadcrumbs << ["Application ##{@application.id}", rating_todos_application_path(@application)]
  end
end