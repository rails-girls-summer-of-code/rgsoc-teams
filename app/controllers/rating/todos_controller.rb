class Rating::TodosController < Rating::BaseController
  respond_to :html

  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Todo', [:rating, :todos] ]
  end

  def index
    @todos = current_user.todos.for_current_season
  end
end
