class Orga::ConferencesController < Orga::BaseController
  before_action :find_conference, only: [:show, :edit, :update, :destroy]

  def index
    @conferences = conferences
  end
  
  def new
    @conference = Conference.new
  end
  
  def create
    @conference = Conference.new(conference_params.merge(season: current_season))
    if @conference.save
     redirect_to orga_conference_path(@conference)
    else
      render action: :new
    end
  end
  
  def update
    if @conference.update(conference_params)
      redirect_to orga_conference_path(@conference)
    else
      render action: :edit
    end
  end

  def destroy
    @conference.destroy!
    redirect_to orga_conferences_path, notice: 'The conference has been deleted.'
  end

  private

  def find_conference
    @conference ||= Conference.find(params[:id])
  end
  
  def conferences
    Conference.ordered(sort_params).in_current_season
  end

  def conference_params
    params.require(:conference).permit(
      :name, :url, :location, :twitter,
      :tickets, :flights, :accomodation,
      :starts_on, :ends_on, :round, :lightningtalkslots,
      attendances_attributes: [:id, :github_handle, :_destroy]
    )
  end

  def sort_params
    {
      order: %w(name location starts_on round).include?(params[:sort]) ? params[:sort] : nil,
      direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
    }
  end

  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Conferences', :conferences]
  end
end
