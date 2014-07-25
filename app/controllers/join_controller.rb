class JoinController < ApplicationController
  before_filter :set_team
  before_filter :allow_helpdesk

  def create
    #authorize! :join, @team
    @team.roles.create!(user: current_user, name: 'helpdesk')
    redirect_to edit_user_url(current_user), flash: { notice: 'You have joined the Helpdesk team. Please make sure your profile is complete. Especially add your IRC handle :)' }
  end

  private

    def set_team
      @team = Team.find(params[:team_id])
    end

    def allow_helpdesk
      redirect_to root_url unless @team.helpdesk?
    end
end
