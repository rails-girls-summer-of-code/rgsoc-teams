class ApplicationDraftsController < ApplicationController
  before_action :checktime, only: [:new, :create]
  before_action :continue_draft, only: :new

  def new
    if signed_in?
      if current_user.student?
        @application_form = ApplicationDraft.new(team: current_user.roles.student.first.team, current_user: current_user)
      else
        redirect_to new_team_path, alert: 'You need to be in a team as a student'
      end
    else
      render 'sign_in'
    end
  end

  protected

  def checktime
    render :ended unless current_season.application_period?
  end

  def continue_draft
    redirect_to open_draft if open_draft
  end

  def open_draft
    current_user.roles.student.first.team.application_drafts.
      where(season_id: current_season.id).first if signed_in?
  end

end
