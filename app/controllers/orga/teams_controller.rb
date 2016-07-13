class Orga::TeamsController < Orga::BaseController
  before_action :find_resource, only: [:show, :edit, :update, :destroy]

  def index
    @display_roles = (Role::TEAM_ROLES + ['supervisor']).map(&:pluralize)

    if params[:sort]
      direction = params[:direction] == 'asc' ? 'ASC' : 'DESC'
      @teams = Team.includes(:activities).order("teams.kind, activities.created_at #{direction}").references(:activities)
    else
      @teams = Team.order(:kind, :name)
    end
    if params[:filter] != 'all'
      @teams = Team.in_current_season.selected.ordered
    end
  end

  def show
  end

  def new
    @team = Team.new
    @team.sources.build(kind: 'blog')
  end

  def edit
    @team.sources.build(kind: 'blog') unless @team.sources.any?
  end

  def create
    @team = Team.new(team_params)
    @team.season = current_season

    respond_to do |format|
      if @team.save
        format.html { redirect_to [:orga, @team], notice: 'Team was successfully created.' }
        format.json { render action: :show, status: :created, location: @team }
      else
        format.html { render action: :new }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @team.update_attributes(team_params)
        format.html { redirect_to [:orga, @team], notice: 'Team was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: :edit }
        format.json { render json: @team.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @team.destroy
    respond_to do |format|
      format.html { redirect_to orga_teams_url }
      format.json { head :no_content }
    end
  end

  private

  def find_resource
    @team = Team.find(params[:id])
  end

  def team_params
    params[:team].fetch(:sources_attributes, {}).delete_if { |key, source| source[:url].empty? }
    params.require(:team).permit(
      :name, :twitter_handle, :github_handle, :description, :post_info, :event_id,
      :checked, :'starts_on(1i)', :'starts_on(2i)', :'starts_on(3i)',
      :'finishes_on(1i)', :'finishes_on(2i)', :'finishes_on(3i)', :invisible,
      :season_id, :kind, :project_name,
      roles_attributes: [:id, :name, :github_handle, :_destroy],
      sources_attributes: [:id, :kind, :url, :_destroy]
    )
  end

end
