class ConferencesController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show]

  include OrderedConferences

  def new
    @conference = Conference.new
  end

  def show
    @conference = Conference.find(params[:id])
  end

  def create
    page_to_redirect = current_user.admin? ? conferences_path : edit_team_path(current_student.current_team)
    @conference = build_conference

    if @conference.save
      redirect_to page_to_redirect, notice: 'Conference was successfully created.'
    else
      render action: :new
    end
  end

  private

  def build_conference
    Conference.new(conference_params.merge(season: current_season, gid: generate_gid))
  end

  def generate_gid
    "#{Season.current.name}-#{Time.now.getutc.to_i}-#{current_user.id}"
  end

  def conference_params
    params.require(:conference).permit(
      :name, :twitter, :starts_on, :ends_on, :notes, :country, :region, :location, :city, :url
    )
  end
end
