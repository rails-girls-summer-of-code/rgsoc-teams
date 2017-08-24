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
    @conference = Conference.new(conference_params)
    @conference.season_id = current_season.id
    @conference.gid = generate_gid(current_user)

    if @conference.save
      redirect
    else
      render action: :new
    end
  end

  def redirect
    message = 'Conference was successfully created.'
    case true
    when current_user.current_student?
      redirect_to edit_team_path(current_student.current_team), notice: message
    when current_user.admin?
      redirect_to orga_conferences_path, notice: message
    else
      redirect_to @conference, notice: message
    end
  end

  private

  def generate_gid(user)
    "#{Season.current.name}-#{Time.now.getutc.to_i}-#{user.id}"
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
    redirect_to root_path, alert: 'You are not authorized to access this page.' unless current_user.admin? || current_user.current_student?
  end

  def sort_params
    {
      order: %w(name gid starts_on city country region).include?(params[:sort]) ? params[:sort] : nil,
      direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
    }
  end
end
