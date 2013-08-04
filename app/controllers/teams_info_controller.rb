class TeamsInfoController < ApplicationController
  # before_filter :normalize_params, only: :index
  before_filter { authorize!(:read, :teams_info) unless current_user.try(:admin?) }

  private

    def teams
      Team.ordered
    end
    helper_method :teams

    # def normalize_params
    #   params[:role] = 'all' if params[:role].blank?
    #   params[:kind] = 'all' if params[:kind].blank?
    # end
end

