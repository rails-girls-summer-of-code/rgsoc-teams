# frozen_string_literal: true

class TeamsInfoController < ApplicationController
  before_action { authorize!(:read, :teams_info) unless current_user.try(:admin?) }

  private

  def teams
    Team.ordered
  end
  helper_method :teams
end
