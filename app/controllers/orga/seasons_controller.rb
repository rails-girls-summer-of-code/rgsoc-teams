class Orga::SeasonsController < Orga::BaseController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  helper_method :switch_seasons

  def switch_seasons
    @fakeseason = current_season
    if params[:option] == 'Application'
      fake_application_phase
    elsif params[:option] == 'CodingSummer'
      fake_coding_phase
    elsif params[:option] == 'RealTime'
      back_to_reality
    end
  end

  def fake_application_phase
    @fakeseason.attributes = {
        starts_at: Date.today+2.months,
        ends_at: Date.today+5.months,
        applications_open_at: Date.today-2.weeks,
        applications_close_at: Date.today+2.weeks,
        acceptance_notification_at: @fakeseason.applications_close_at+1.month
    }
    @fakeseason.save
  end

  def fake_coding_phase
    @fakeseason.attributes = {
        starts_at: Date.today-6.weeks,
        ends_at: Date.today+6.weeks,
        applications_open_at: Date.today-4.months,
        applications_close_at: Date.today-3.months,
        acceptance_notification_at: Date.today-2.months
    }
    @fakeseason.save
  end

  def back_to_reality
    @season.attributes = {
        name: Date.today.year,
        starts_at: Time.utc(Date.today.year, 7, 15),
        ends_at: Time.utc(Date.today.year, 9, 30),
        applications_open_at: Time.utc(Date.today.year, 3, 1),
        applications_close_at: Time.utc(Date.today.year, 3, 31),
        acceptance_notification_at: Time.utc(Date.today.year, 5, 1)
    }
    @season.save
  end



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
      :acceptance_notification_at
    )
  end

end
