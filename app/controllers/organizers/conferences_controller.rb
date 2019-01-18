# frozen_string_literal: true

module Organizers
  class ConferencesController < Organizers::BaseController
    before_action :find_conference, only: [:show, :destroy]
    before_action :ensure_file_was_posted, only: :import

    include OrderedConferences

    def import
      begin
        ConferenceImporter.call(params[:file].path, content_type: params[:file].content_type)
        flash[:notice] = "Import finished! Check log for errors."
      rescue ArgumentError => e
        flash[:alert] = "Import failed: #{e.message}"
      end

      redirect_to organizers_conferences_path
    end

    def show
    end

    def new
      @conference = Conference.new
    end

    def create
      @conference = Conference.new(conference_params)
      @conference.season_id = current_season.id
      @conference.gid = generate_gid(current_user)

      if @conference.save
        redirect_to organizers_conferences_path, notice: 'Conference was successfully created.'
      else
        render action: :new
      end
    end

    def destroy
      @conference.destroy!
      redirect_to organizers_conferences_path, notice: 'The conference has been deleted.'
    end

    private

    def generate_gid(user)
      "#{Season.current.name}-#{Time.now.getutc.to_i}-#{user.id}"
    end

    def find_conference
      @conference ||= Conference.find(params[:id])
    end

    def conference_params
      params.require(:conference).permit(
        :name, :location, :city, :country, :region,
        :url, :twitter,
        :starts_on, :ends_on,
        :gid, # id in orga's Google Spreadsheet (format: 2017001)
        :notes,
        conference_preferences_attributes: [:id, :_destroy]
      )
    end

    def set_breadcrumbs
      super
      @breadcrumbs << ['Conferences', :conferences]
    end

    def ensure_file_was_posted
      unless params[:file]
        redirect_to organizers_conferences_path, alert: 'Error: No file submitted.' and return
      end
    end
  end
end
