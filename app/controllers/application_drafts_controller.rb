class ApplicationDraftsController < ApplicationController
  before_action :checktime
  before_action :sign_in_required
  before_action :continue_draft, only: :new

  helper_method :application_draft

  def new
    redirect_to new_team_path, alert: 'You need to be in a team as a student' unless current_user.student?
  end

  def create
    application_draft.assign_attributes(application_draft_params)
    if application_draft.save
      redirect_to [:edit, application_draft], notice: 'Your application draft was saved.'
    else
      render :new
    end
  end

  def edit
    redirect_to root_path, alert: 'Not part of a team' and return unless current_team
    application_draft
    render :new
  end

  def update
    if application_draft.update(application_draft_params)
      redirect_to [:edit, application_draft], notice: 'Your application draft was saved.'
    else
      render :new
    end
  end

  protected

  def application_draft
    @application_draft ||= if params[:id]
                             current_team.application_drafts.find(params[:id])
                           else
                             current_team.application_drafts.new(team: current_team)
                           end.tap { |draft| draft.current_user = current_user }
  end

  def application_draft_params
    if application_draft.as_student?
      params.require(:application_draft).
        permit(:project_name, :project_url, :misc_info, :heard_about_it, :voluntary, :voluntary_hours_per_week)
    elsif application_draft.as_coach?
      params.require(:application_draft).
        permit(:coaches_contact_info, :coaches_hours_per_week, :coaches_why_team_successful)
    end
  end

  def checktime
    render :ended unless current_season.application_period?
  end

  def continue_draft
    redirect_to [:edit, open_draft] if open_draft
  end

  def current_team
    current_user.roles.student.first.try :team
  end

  def open_draft
    current_team.application_drafts.
      where(season_id: current_season.id).first if signed_in? && current_team
  end

  def sign_in_required
    render 'sign_in' unless signed_in?
  end

end
