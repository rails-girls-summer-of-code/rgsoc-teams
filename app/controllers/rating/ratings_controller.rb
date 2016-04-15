class Rating::RatingsController < Rating::BaseController

  def create
    rating = find_or_initialize_rating
    rating.update(rating_attr_params)
    redirect_to rating_todos_path
  end

  def update
    rating = Rating.by(current_user).find(params[:id])
    rating.update(rating_attr_params)
    redirect_to rating_todos_path
  end

  private

  def rating_attr_params
    params.require(:rating).permit(:pick, Rating::FIELDS.keys)
  end

  def find_or_initialize_rating
    rateable_args = params[:rating].values_at(:rateable_type, :rateable_id)
    Rating.by(current_user).for(*rateable_args).first_or_initialize
  end
end
