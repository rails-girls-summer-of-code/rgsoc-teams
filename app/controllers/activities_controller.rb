class ActivitiesController < ApplicationController
  def index
    @activities = Activity.includes(:team).order('published_at DESC')
  end
end

