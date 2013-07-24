class UsersInfoController < ApplicationController
  before_filter :normalize_params, only: :index
  before_filter { authorize!(:read, :users_info) if cannot?(:read, :users_info) }

  private

    def users
      users = User.includes(:teams).ordered
      users = users.with_role(params[:role]) if params[:role].present? && params[:role] != 'all'
      users = users.with_team_kind(params[:kind]) if params[:kind].present? && params[:kind] != 'all'
      users
    end
    helper_method :users

    def normalize_params
      params[:role] = 'all' if params[:role].blank?
      params[:kind] = 'all' if params[:kind].blank?
    end
end
