class ApplicationDraftsController < ApplicationController

  before_action :checktime
  before_action :sign_in_required
  before_action :ensure_max_applications, only: :new
  before_action :disallow_modifications_after_submission, only: :update

  helper_method :application_draft

  def index
    @application_drafts = current_user.application_drafts.order('position ASC')
  end

  def new
    redirect_to new_team_path, alert: 'You need to be in a team as a student' unless current_user.student?
  end

  def create
    application_draft.assign_attributes(application_draft_params)
    if application_draft.save
      update_student!
      notice = "Your application draft was saved. You can access it under »#{view_context.link_to "My applications", apply_path}«".html_safe
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

  def check
    if application_draft.valid?(:apply)
      flash[:notice] = "You're ready to apply \o/"
    else
      flash[:alert]  = 'There are still some fields missing'
    end
    render :new
  end

  def prioritize
    application_draft.insert_at(1)
    redirect_to application_drafts_url
  end

  protected

  def application_draft
    @application_draft ||= if params[:id]
                             current_team.application_drafts.find(params[:id])
                           else
                             current_team.application_drafts.new(team: current_team)
                           end.tap { |draft| draft.assign_attributes(current_user: current_user, updater: current_user) }
  end

  def application_draft_params
    if application_draft.as_student?
      params.require(:application_draft).
        permit(:project_name, :project_url, :project_plan, :misc_info, :heard_about_it, :voluntary, :voluntary_hours_per_week)
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
          :name, :application_about, :application_motivation, :application_gender_identification,
          :application_coding_level, :application_community_engagement, :application_learning_period,
          :application_learning_history, :application_skills,
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

  def disallow_modifications_after_submission
    if application_draft.applied?
      redirect_to application_drafts_path, alert: 'You cannot modify this application anymore'
    end
  end

  def ensure_max_applications
    if current_student.current_drafts.size > 1
      redirect_to application_drafts_path, alert: 'You cannot lodge more than two applications'
    end
  end

  def current_team
    current_student.current_team || coaches_team
  end

  def coaches_team
    @coaches_team ||= begin
                        team = ApplicationDraft.find(params[:id]).team
                        team if team.coaches.include? current_user
                      end
  end

  def open_draft
    current_student.current_draft if signed_in?
  end

  def sign_in_required
    render 'sign_in' unless signed_in?
  end

end
