class CommunityUsers

  def initialize(params, users)
    @users         = users
    @role          = params[:role].presence
    @interest      = params[:interest].presence
    @availability  = params[:availability].presence
    @search        = params[:search].presence
    @location      = params[:location].presence
    @page          = params[:page].presence
  end

  def all
    @users = @users.with_assigned_roles if current_season_has_begun?
    @users = @users.with_role(@role) if role_present?
    @users = @users.with_interest(@interest) if interest_present?
    @users = @users.as_coach_availability if coach_availability_present?
    @users = Kaminari.paginate_array(@users.search(@search)) if search_present?
    @users = @users.with_location(@location) if location_present?
    @users = @users.page(@page)
  end

  private

  def current_season_has_begun?
    Time.now.utc > (Season.current.starts_at || Date.new)
  end

  def role_present?
    @role.present? && @role != 'all'
  end

  def interest_present?
    @interest.present? && @interest != 'all'
  end

  def coach_availability_present?
    @availability.present?
  end

  def search_present?
    @search.present?
  end

  def location_present?
    @location.present?
  end
end
