class ConferencesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]
  before_action :confirm_role, except: [:index, :show]

  def new
    @conference = Conference.new
  end

  def index
    @conferences = conferences
  end
 
  def show
    @conference = Conference.find(params[:id])
  end

  def create
    team = current_user.student_team
    @conference = build_conference

    if @conference.save
      path = team.present? ? edit_team_path(team) : conferences_path
      redirect_to path, notice: 'Conference was successfully created.'
    else
      render action: :new
    end
  end

  def redirect
    redirect_to orga_conferences_path
  end

  private

  def build_conference
    Conference.new(conference_params.merge(season: current_season, gid: generate_gid))
  end

  def generate_gid
    "#{Season.current.name}-#{Time.now.getutc.to_i}-#{current_user.id}"
  end
 
  def conferences
    Conference.ordered(sort_params).in_current_season
  end

  def conference_params
    params.require(:conference).permit(
      :name, :twitter, :starts_on, :ends_on, :notes, :country, :region, :location, :city, :url
    )
  end

  def confirm_role
    redirect unless current_user.admin? || current_user.student?
  end

  def sort_params
    {
      order: %w(name gid starts_on city country region).include?(params[:sort]) ? params[:sort] : nil,
      direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
    }
  end
end
