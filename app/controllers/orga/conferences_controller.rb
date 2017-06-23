class Orga::ConferencesController < Orga::BaseController

  def new
    @conference = Conference.new
  end
  
  def create
    @conference = Conference.new(conference_params)
    @conference.season = current_season
    respond_to do |format|
      if @conference.save
        format.html { redirect_to orga_conference_path(conference) }
      else
        format.html { render action: :new }
      end
    end
  end

  def update
    if conference.update(conference_params)
      redirect_to orga_conference_path(conference)
    else
      render action: :edit
    end
  end

  def destroy
    conference.destroy!
    redirect_to orga_conferences_path, notice: 'The conference has been deleted.'
  end

  private

  def conferences
    @conferences ||= Conference.ordered(sort_params).in_current_season
  end
  helper_method :conferences
  
  def conference
    @conference ||= Conference.find(params[:id])
  end
  helper_method :conference

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
