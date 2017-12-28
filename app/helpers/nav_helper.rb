# frozen_string_literal: true
module NavHelper
  SOC_CONTROLLER = %w(conferences projects applications application_drafts teams users)

  def dropdown_active?
    'active' if SOC_CONTROLLER.include?(params[:controller])
  end

  def active?(controller_name)
    'active' if params[:controller] == controller_name.to_s
  end

  def during_application_phase?
    current_season.application_period? ||
      (Time.now.utc.between? current_season.applications_close_at, current_season.acceptance_notification_at)
  end

  def during_season?
    current_season.started? && !current_season.transition?
  end
end
