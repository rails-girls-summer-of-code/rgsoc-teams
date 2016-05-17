class Rating::Todos::ApplicationsController < Rating::ApplicationsController
  PATH_PARENTS = [:rating, :todos]


  def set_breadcrumbs
    @breadcrumbs = [ ['Rating', :rating], ['Todos', [:rating, :todos]] ]
  end
end