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
    community = CommunityUsers.new(params.dup, @users)
    @users = community.all
  end

  private

  def normalize_params
    params[:role] = 'all' if params[:role].blank?
  end
end
