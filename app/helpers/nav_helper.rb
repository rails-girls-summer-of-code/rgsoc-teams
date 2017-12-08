# frozen_string_literal: true
module NavHelper
  SOC_CONTROLLER = %w(conferences projects applications application_drafts teams users)

  def dropdown_active?
    'active' if SOC_CONTROLLER.include?(params[:controller])
  end

  def active?(controller_name)
    'active' if params[:controller] == controller_name.to_s
  end
end
