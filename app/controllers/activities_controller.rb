class ActivitiesController < ApplicationController
  before_action :normalize_params, only: :index
  before_action :cors_preflight, only: :index
  after_action  :cors_set_headers, only: :index

  before_action :set_activities

  def index
    respond_to do |format|
      format.html
      format.json { render json: @activities }
      format.atom { render :layout => false  }
    end
  end

  private

    def set_activities
      @activities = Activity.includes(:team).ordered.page(params[:page])
      @activities = @activities.with_kind(params[:kind]) if params[:kind].present? && params[:kind] != 'all'
      @activities = @activities.by_team(params[:team_id]) if params[:team_id].present?
    end

    def teams
      Team.order(:name)
    end
    helper_method :teams

    def normalize_params
      params[:kind] = 'all' if params[:kind].blank?
    end
end

