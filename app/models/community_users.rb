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
    @users = @users.with_role(@role) if present? @role
    @users = @users.with_interest(@interest) if present? @interest
    @users = @users.as_coach_availability if present? @availability
    @users = Kaminari.paginate_array(@users.search(@search)) if present? @search
    @users = @users.with_location(@location) if present? @location
    @users = @users.page(@page)
  end

  private

  def current_season_has_begun?
    Time.now.utc > (Season.current.starts_at || Date.new)
  end

  def present?(param)
    param.present? && param != 'all'
  end
end
