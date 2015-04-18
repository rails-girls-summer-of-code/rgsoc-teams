class RatingsController < ApplicationController
  before_action :authenticate_user!
  before_filter :normalize_data

  def create
    rating = find_or_initialize_rating
    rating.update_attributes(rating_params)
    redirect_to params[:return_to]
  end

  def update
    rating = Rating.find(params[:id])
    rating.update_attributes(rating_params)
    redirect_to params[:return_to]
  end

  private

  def rating_params
    params.require(:rating).permit(:pick, :rateable_type, :rateable_id, data: RatingData::FIELDS).tap { |d| p d }
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
end
