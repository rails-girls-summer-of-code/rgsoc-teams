# frozen_string_literal: true

module OrderedConferences
  def index
    @conferences = Conference.ordered(sort_params).in_current_season
  end

  private

  def sort_params
    {
      order: %w(name gid starts_on city country region).include?(params[:sort]) ? params[:sort] : nil,
      direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
    }
  end
end
