class Orga::ConferencesController < Orga::BaseController
  before_action :find_conference, only: [:show, :destroy]

  def import
    Conference::Importer.call(params[:file].path, content_type: params[:file].content_type)
    redirect_to orga_conferences_path, notice: "Import finished! Check log for errors."
  end

  def index
    @conferences = conferences
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
      :name, :location, :city, :country, :region,
      :url, :twitter,
      :starts_on, :ends_on,
      :round, :lightningtalkslots, :tickets, :flights, :accomodation,
      :gid, #id in orga's Google Spreadsheet (format: 2017001)
      :notes,
      conference_preferences_attributes: [:id, :github_handle, :_destroy]
    )
  end

  def sort_params
    {
      order: %w(name gid starts_on city country region).include?(params[:sort]) ? params[:sort] : nil,
      direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
    }
  end

  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Conferences', :conferences]
  end
end
