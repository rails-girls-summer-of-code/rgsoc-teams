class Orga::SeasonsController < Orga::BaseController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def new
    @season = Season.new({
      name: Date.today.year,
      starts_at: Time.utc(Date.today.year, 7, 1),
      ends_at: Time.utc(Date.today.year, 9, 30),
      applications_open_at: Time.utc(Date.today.year, 3, 1),
      applications_close_at: Time.utc(Date.today.year, 3, 31),
      acceptance_notification_at: Time.utc(Date.today.year, 5, 1)
    })
  end

  def create
    build_resource
    if @season.save
      redirect_to [:orga, @season], notice: "Season #{@season.name} created."
    else
      render 'new'
    end
  end

  def show
  end

  def index
    @seasons = Season.order('name DESC')
  end

  def edit
  end

  def update
    if @season.update season_params
      redirect_to orga_seasons_path, notice: "Season #{@season.name} updated."
    else
      render 'edit'
    end
  end

  def destroy
    @season.destroy
    redirect_to orga_seasons_path, notice: "Season #{@season.name} has been deleted."
  end

  # # switch_phase: enables developers to easily switch between time dependent settings in views
  # by opening and closing the corresponding links in the nav bar
  def switch_phase
    return if Rails.env.production?
    @season = current_season
      case params[:option]
      when 'Proposals'
        @season.fake_proposals_phase
      when 'Application'
        @season.fake_application_phase
      when 'CodingSummer'
        @season.fake_coding_phase
      when 'RealTime'
        @season.back_to_reality
      end
    redirect_to orga_seasons_path, notice: "We time travelled into the #{params[:option]} phase"
  end


  private

  def build_resource
    @season = Season.new season_params
  end

  def find_resource
    @season = Season.find params[:id]
  end

  def season_params
    params.require(:season).permit(
      :name, :starts_at, :ends_at,
      :applications_open_at, :applications_close_at,
      :acceptance_notification_at,
      :project_proposals_open_at,
      :project_proposals_close_at
    )
  end

end
