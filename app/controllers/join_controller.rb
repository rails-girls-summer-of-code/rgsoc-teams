# frozen_string_literal:  true

class JoinController < ApplicationController
  before_action :set_team
  before_action :allow_helpdesk

  def create
    @team.roles.create!(user: current_user, name: 'helpdesk')
    redirect_to edit_user_url(current_user), flash: { notice: 'You have joined the Helpdesk team. Please make sure your profile is complete. Especially add your IRC handle :)' }
  end

  private

  def set_team
    @team = Team.find(params[:team_id])
  end

  def allow_helpdesk
    redirect_back fallback_location: teams_url, alert: 'Sorry, only Helpdesk supporters can use this function.' unless @team.helpdesk_team?
  end
end
