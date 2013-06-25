class ActivitiesController < ApplicationController
  def index
    @activities = Activity.includes(:team).ordered
  end
end

