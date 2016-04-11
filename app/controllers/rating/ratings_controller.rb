class Rating::RatingsController < Rating::BaseController
  before_action :normalize_data

  def create
    rating = find_or_initialize_rating
    rating.update(rating_attr_params)
    redirect_to next_path(rating.rateable)
  end

  def update
    rating = Rating.by(current_user).find(params[:id])
    rating.update(rating_attr_params)
    redirect_to next_path(rating.rateable)
  end

  private

  def rating_attr_params
    params.require(:rating).permit(:pick, data: RatingData::FIELDS.keys)
  end

  def normalize_data
    data = params[:rating][:data]
    data.each do |key, value|
      next unless value
      data[key] = value.to_i
      data[key] = 10 if data[key] > 10 && key != 'min_money'
    end
  end

  def find_or_initialize_rating
    rateable_args = params[:rating].values_at(:rateable_type, :rateable_id)
    Rating.by(current_user).for(*rateable_args).first_or_initialize
  end

  def next_path(current)
    if subject = Application::Todo.new(current_user, current).next
      send(PATHS[subject.class.name.underscore.to_sym], subject)
    else
      Application
    end
  end

  PATHS = {
    user: 'rating_student_path',
    team: 'rating_team_path',
    application: 'rating_application_path'
  }
end
