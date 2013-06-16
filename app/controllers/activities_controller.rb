class ActivitiesController < ApplicationController
  def index
    @activities = Activity.includes(:team).order('created_at DESC')
  end
end

