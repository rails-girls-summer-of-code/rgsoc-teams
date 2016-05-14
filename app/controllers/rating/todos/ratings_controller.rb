class Rating::Todos::RatingsController < Rating::RatingsController

  private
    def set_redirect_path
      @redirect_path = rating_todos_path
    end
end