class Orga::CommunityController < Orga::BaseController
  before_action :normalize_params, only: :index

  def index
    @filters = {
      all:        'All',
      pair:       'Looking for a pair',
      coaching:   'Helping as a Coach',
      mentoring:  'Helping as a Mentor',
      organizing: 'Helping as an Organizer'
    }
    @users = User.ordered(params[:sort],params[:direction])
        .group('users.id').with_all_associations_joined
    @users = @users.with_assigned_roles if Time.now.utc > (current_season.starts_at || Date.new)
    @users = @users.with_role(params[:role]) if params[:role].present? && params[:role] != 'all'
    @users = @users.with_interest(params[:interest]) if params[:interest].present? && params[:interest] != 'all'
    @users = Kaminari.paginate_array(@users.search(params[:search])).page(params[:page])
  end

  def reset_user_availability
    if User::AvailabilitySwitcher.reset
      redirect_to orga_users_info_path, flash: { notice: 'Coaches were reset with success.' }
    else
      redirect_to orga_users_info_path, flash: { danger: 'Coaches were not reset.' }
    end
  end

  private

  def normalize_params
    params[:role] = 'all' if params[:role].blank?
  end
end