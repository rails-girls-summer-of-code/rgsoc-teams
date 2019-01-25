# frozen_string_literal: true

module Organizers
  class SeasonsController < Organizers::BaseController
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
        redirect_to [:organizers, @season], notice: "Season #{@season.name} created."
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
        redirect_to organizers_seasons_path, notice: "Season #{@season.name} updated."
      else
        render 'edit'
      end
    end

    def destroy
      @season.destroy
      redirect_to organizers_seasons_path, notice: "Season #{@season.name} has been deleted."
    end

    # # switch_phase: enables developers to easily switch between time dependent settings in views
    # by showing the corresponding links in the nav bar
    def switch_phase
      return if Rails.env.production?
      DevUtils::SeasonPhaseSwitcher.destined(phase)
      redirect_to organizers_seasons_path, notice: "We time travelled into the #{params[:phase].humanize.titlecase}"
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

    def phase
      params[:phase].to_sym
    end

    def set_breadcrumbs
      super
      @breadcrumbs << ['Seasons', :seasons]
    end
  end
end
