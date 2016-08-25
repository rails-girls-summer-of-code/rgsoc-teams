class ActivitiesController < ApplicationController
  before_action :normalize_params, only: :index
  before_action :cors_preflight, only: :index
  after_action  :cors_set_headers, only: :index

  before_action :set_activities

  def index
    @team = Team.find_by id: params[:team_id] if params[:team_id]
    respond_to do |format|
      format.html
      format.json { render json: @activities }
      format.atom { render :layout => false  }
    end
  end

  private

    def set_activities
      @activities = Activity.includes(:team).with_kind(whitelisted_kind).ordered.page(params[:page])
      @activities = @activities.by_team(params[:team_id]) if params[:team_id].present?
    end

    def teams
      Team.in_current_season.selected.order(:name)
    end
    helper_method :teams

    def normalize_params
      params[:kind] = 'all' if params[:kind].blank?
    end

    def whitelisted_kind
      @whitelisted_kind ||= Array(params[:kind]).detect { |kind| public_activities.include? kind } || public_activities
    end

    def public_activities
      @public_activities ||= %w(feed_entry status_update)
    end
    helper_method :public_activities
end

