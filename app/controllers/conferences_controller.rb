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
    @conference = Conference.new(conference_params)
    @conference.season_id = current_season.id
    @conference.gid = generate_gid(team)

    if @conference.save
      redirect_to edit_team_path(team), notice: 'Conference was successfully created.'
    else
      render action: :new
    end
  end

  def redirect
    redirect_to orga_conferences_path
  end

  private

  def generate_gid(team)
    "#{Season.current.name}-#{Time.now.getutc.to_i}-#{team.id}"
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
