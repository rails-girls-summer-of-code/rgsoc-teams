class ActivitiesController < ApplicationController
  before_filter :cors_preflight, only: :index
  after_filter  :cors_set_headers, only: :index

  before_filter :set_activities

  def index
    respond_to do |format|
      format.html
      format.json { render json: @activities }
      format.atom { render :layout => false  }
    end
  end

  private

    def set_activities
      @activities = Activity.includes(:team).ordered
    end
end

