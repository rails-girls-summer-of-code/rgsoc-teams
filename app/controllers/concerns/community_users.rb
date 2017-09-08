class CommunityUsers

  def initialize(params, users)
    @params = params
    @users = users
  end

  def filtered_users
    @users = @users.with_assigned_roles if Time.now.utc > (Season.current.starts_at || Date.new)
    @users = @users.with_role(@params[:role]) if @params[:role].present? && @params[:role] != 'all'
    @users = @users.with_interest(@params[:interest]) if @params[:interest].present? && @params[:interest] != 'all'
    @users = @users.as_coach_availability if @params[:availability].present?
    @users = Kaminari.paginate_array(@users.search(@params[:search])) if @params[:search].present?
    @users = @users.with_location(@params[:location]) if @params[:location].present?
    @users = @users.page(@params[:page])
  end
end