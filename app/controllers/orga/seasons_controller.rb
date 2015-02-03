class Orga::SeasonsController < Orga::BaseController

  def new
    starts_at = Time.utc(Date.today.year, 7, 1)
    ends_at   = Time.utc(Date.today.year, 9, 30)
    @season   = Season.new(starts_at: starts_at, ends_at: ends_at)
  end

  def create
    @season = Season.new(season_params)
    if @season.save
      redirect_to [:orga, @season], notice: "Season #{@season.name} created."
    else
      render 'new'
    end
  end

  def show
    @season = Season.find params[:id]
  end

  def index
    @seasons = Season.all
  end

  def edit
    @season = Season.find params[:id]
  end

  def update
    @season = Season.find params[:id]
    if @season.update season_params
      redirect_to orga_seasons_path, notice: "Season #{@season.name} updated."
    else
      render 'edit'
    end
  end

  def destroy
    @season = Season.find params[:id]
    @season.destroy
    redirect_to orga_seasons_path, notice: "Season #{@season.name} has been deleted."
  end

  private

  def season_params
    params.require(:season).permit(:name, :starts_at, :ends_at)
  end

end
