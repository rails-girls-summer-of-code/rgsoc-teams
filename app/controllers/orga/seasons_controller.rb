class Orga::SeasonsController < Orga::BaseController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def new
    @season = Season.new({
      name: Date.today.year,
      starts_at: DateTime.parse("#{Date.today.year}-07-01"),
      ends_at: DateTime.parse("#{Date.today.year}-09-30"),
      applications_open_at: DateTime.parse("#{Date.today.year}-03-01"),
      applications_close_at: DateTime.parse("#{Date.today.year}-03-31")
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
    params.require(:season).permit(:name, :starts_at, :ends_at)
  end

end
