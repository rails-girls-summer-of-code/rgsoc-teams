class Rating::TodosController < Rating::BaseController
  respond_to :html

  include TodoHelper

  def index
    @teams = Team.joins(:applications)
                 .where('"applications_count" > 0')
                 .where(season: current_season)
                 .includes(:students, :applications)
  end
end
