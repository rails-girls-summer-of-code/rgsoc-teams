class ConferencesController < ApplicationController
 before_action :redirect, except: [:index, :show, :new, :create]

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
    generate_gid(@conference)

    respond_to do |format|
      if @conference.save
        format.html { redirect_to params[:redirect_to].presence || @conference, notice: 'Conference was successfully created.' }
        format.json { render action: :show, status: :created, location: @conference }
      else
        format.html { render action: :new }
        format.json { render json: @conference.errors, status: :unprocessable_entity }
      end
    end
  end

  def redirect
    redirect_to orga_conferences_path
  end

  private

  def generate_gid(conference)
    conference.gid = Time.now.getutc
  end
 
  def conferences
    Conference.ordered(sort_params).in_current_season
  end

  def conference_params
    byebug
    params.require(:conference).permit(
      :name, :twitter, :starts_on, :ends_on, :notes, :country, :region, :location, :city, :url, :season_id
    )
  end

  def sort_params
    {
      order: %w(name gid starts_on city country region).include?(params[:sort]) ? params[:sort] : nil,
      direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
    }
  end
end
