class Orga::ConferencesController < Orga::BaseController
  before_action :find_conference, only: [:show, :destroy]
  before_action :ensure_file_was_posted, only: :import

  include OrderedConferences

  def import
    begin
      Conference::Importer.call(params[:file].path, content_type: params[:file].content_type)
      flash[:notice] = "Import finished! Check log for errors."
    rescue ArgumentError => e
      flash[:alert] = "Import failed: #{e.message}"
    end

    redirect_to orga_conferences_path
  end

  def destroy
    @conference.destroy!
    redirect_to orga_conferences_path, notice: 'The conference has been deleted.'
  end

  private

  def find_conference
    @conference ||= Conference.find(params[:id])
  end

  def conference_params
    params.require(:conference).permit(
      :name, :location, :city, :country, :region,
      :url, :twitter,
      :starts_on, :ends_on,
      :round, :lightningtalkslots, :tickets, :flights, :accomodation,
      :gid, #id in orga's Google Spreadsheet (format: 2017001)
      :notes,
      conference_preferences_attributes: [:id, :_destroy]
    )
  end

  def set_breadcrumbs
    super
    @breadcrumbs << [ 'Conferences', :conferences]
  end

  def ensure_file_was_posted
    unless params[:file]
      redirect_to orga_conferences_path, alert: 'Error: No file submitted.' and return
    end
  end
end
