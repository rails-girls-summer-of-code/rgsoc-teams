class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_filter :normalize_data

  def create
    rating = find_or_initialize_rating
    rating.update_attributes(rating_params)
    redirect_to rating.application
  end

  def update
    rating = Rating.find(params[:id])
    rating.update_attributes(rating_params)
    redirect_to rating.application
  end

  private

  def rating_params
    params.require(:rating).permit(data: RatingData::FIELDS)
  end

  def normalize_data
    data = params[:rating][:data]
    data.each do |key, value|
      if value
        data[key] = value.to_i
        data[key] = 10 if data[key] > 10
      end
    end
  end

  def find_or_initialize_rating
    application = Application.find(params[:application_id])
    rating = application.ratings.by(current_user).first || application.ratings.new
    rating.user = current_user if rating.user.blank?

    rating
  end
end
