class CommunityController < ApplicationController
  before_action :normalize_params, only: :index

  def index
    @filters = {
      all:        'All',
      pair:       'Looking for a pair',
      coaching:   'Helping as a Coach',
      mentoring:  'Helping as a Mentor',
      organizing: 'Helping as an Organizer'
    }

    @countries = User.pluck(:country)
    @users = User.ordered(params[:sort],params[:direction])
        .group('users.id').with_all_associations_joined
    @users = @users.with_assigned_roles if Time.now.utc > (current_season.starts_at || Date.new)
    @users = @users.with_role(params[:role]) if params[:role].present? && params[:role] != 'all'
    @users = @users.with_interest(params[:interest]) if params[:interest].present? && params[:interest] != 'all'
    @users = @users.as_coach_availability if params[:availability].present?
    @users = Kaminari.paginate_array(@users.search(params[:search])) if params[:search].present?
    @users = @users.with_location(params[:location]) if params[:location].present?
    @users = @users.page(params[:page])
  end

  private

  def normalize_params
    params[:role] = 'all' if params[:role].blank?
  end
end