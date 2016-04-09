class Applications::TeamsController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_role 'reviewer' }
  respond_to :html

  def show
    @team = Team.find(params[:id])
    @applications = @team.applications
    @rating = find_or_initialize_rating(@team)
    @data = RatingData.new(@rating.data)
  end

  private

  def find_or_initialize_rating(rateable)
    @team.ratings.find_or_initialize_by(user: current_user)
  end
end
