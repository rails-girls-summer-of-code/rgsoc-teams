# frozen_string_literal: true

module Reviewers
  class RatingsController < Reviewers::BaseController
    # In order to get the rating data persisted, FIRST create the rating record,
    # then update it to actually set the values.
    def create
      rating = find_or_create_rating
      rating.update new_rating_params
      redirect_to reviewers_todos_path
    end

    def update
      rating = Rating.by(current_user).find(params[:id])
      rating.update(rating_attr_params)
      redirect_to reviewers_todos_path
    end

    private

    def new_rating_params
      params.require(:rating).permit(:application_id, :like, :pick, Rating::FIELDS.keys)
    end

    def rating_attr_params
      params.require(:rating).permit(:like, :pick, Rating::FIELDS.keys)
    end

    def find_or_create_rating
      application = Application.find_by(id: new_rating_params[:application_id])
      application.ratings.by(current_user).first_or_create
    end
  end
end
