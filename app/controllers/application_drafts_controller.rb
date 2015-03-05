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
      update_student!
      notice = "Your application draft was saved. You can access it under »#{view_context.link_to "My application", apply_path}«".html_safe
      redirect_to [:edit, application_draft], notice: notice
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
      update_student!
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

  def student_params
    # TODO make sure we are the student set to be updated
    if application_draft.as_student? and params[:student]
      # TODO: Do we need an index? Maybe just compare id with current_student.id
      params[:student].
        permit(
          :name, :application_about, :application_gender_identification, :application_coding_level,
          :application_code_samples, :application_location, :banking_info, :application_minimum_money
      )
    else
      {}
    end
  end

  def update_student!
    current_student.update!(student_params) if application_draft.as_student?
  end

  def checktime
    render :ended unless current_season.application_period?
  end

  def continue_draft
    redirect_to [:edit, open_draft] if open_draft
  end

  def current_team
    current_student.current_team
  end

  def open_draft
    current_student.current_draft if signed_in?
  end

  def sign_in_required
    render 'sign_in' unless signed_in?
  end

end
