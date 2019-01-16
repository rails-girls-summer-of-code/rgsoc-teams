# frozen_string_literal: true

module NavHelper
  SOC_CONTROLLERS = %w(conferences projects applications application_drafts teams community).freeze

  def active_if_soc_dropdown_active
    'active' if SOC_CONTROLLERS.include?(params[:controller])
  end

  def active_if(path)
    'active' if current_page?(path)
  end

  def active_if_controller(controller)
    'active' if params[:controller] == controller
  end

  def during_application_phase?
    current_season.application_period? ||
      (Time.now.utc.between? current_season.applications_close_at, current_season.acceptance_notification_at)
  end

  def during_season?
    current_season.started? && !current_season.transition?
  end
end
