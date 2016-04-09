class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_action :normalize_data

  def create
    rating = find_or_initialize_rating
    rating.update_attributes(rating_params)
    redirect_to next_path(rating.rateable)
  end

  def update # maybe different params hash for update? (why can I stil change rateable_type and id)
    rating = Rating.find(params[:id])
    rating.update_attributes(rating_params)
    redirect_to next_path(rating.rateable)
  end

  private

  def rating_params
    params.require(:rating).permit(:pick, :rateable_type, :rateable_id, data: RatingData::FIELDS)
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
    rating = Rating.by(current_user).for(params[:rating][:rateable_type], params[:rating][:rateable_id])
    rating = rating.first_or_initialize
    rating
  end

  def next_path(current)
    if subject = Application::Todo.new(current_user, current).next
      send(PATHS[subject.class.name.underscore.to_sym], subject)
    else
      Application
    end
  end

  PATHS = {
    user: 'applications_student_path',
    team: 'applications_team_path',
    application: 'application_path'
  }
end
