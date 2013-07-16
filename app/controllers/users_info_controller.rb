class UsersInfoController < ApplicationController
  before_filter { authorize!(:read, :users_info) if cannot?(:read, :users_info) }

  private

    def users
      users = User.ordered
      users = users.with_role(params[:role]) if params[:role].present? && params[:role] != 'all'
      users
    end
    helper_method :users
end
