class ApplicationDraftsController < ApplicationController

  before_action :checktime, only: [:new, :create, :update]
  before_action :sign_in_required
  before_action :ensure_max_applications, only: :new
  before_action :disallow_modifications_after_submission, only: :update
  before_action -> { require_role 'student' }, except: [:new]

  helper_method :application_draft

  def index
    @application_drafts = current_user.application_drafts.in_current_season
    redirect_to [:edit, @application_draft] and return if @application_draft = @application_drafts.first
  end

  def new
    if current_user.student?
      redirect_to root_path, alert: 'You need to have a partner in your team to create an application.' unless current_team.confirmed?
    else
      redirect_to new_team_path, alert: 'You need to be in a team as a student to create an application.'
    end
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

  def apply
    if current_team.coaches_confirmed?
      if application_draft.ready? && application_draft.submit_application!
        flash[:notice] = 'Your application has been submitted!'
        ApplicationFormMailer.new_application(application_draft.application).deliver_later
      else
        flash[:alert]  = 'An error has occurred. Please contact us.'
      end
      redirect_to application_drafts_path
    else
      flash[:alert] = %Q[Your coaches have not all confirmed their membership. See <a href="#{team_path(current_team)}">your team</a> for more info.].html_safe
      redirect_to application_drafts_path
    end
  end

  protected

  def application_draft
    @application_draft ||= if params[:id]
                             current_team.application_drafts.in_current_season.find(params[:id])
                           else
                             current_team.application_drafts.in_current_season.new(team: current_team)
                           end.tap { |draft| draft.assign_attributes(current_user: current_user, updater: current_user) }
  end

  def application_draft_params
    params.require(:application_draft).
      permit(:project1_id, :project2_id, :project_plan, :misc_info, :voluntary, :voluntary_hours_per_week, :working_together, :why_selected_project, heard_about_it: [])
  end

  def student_params
    if application_draft.as_student? and params[:student]
      params[:student].fetch(current_user.id.to_s, {}).
        permit(
          :name, :application_about, :application_motivation, :application_gender_identification, :application_diversity, :application_age,
          :application_coding_level, :application_community_engagement, :application_giving_back,
          :application_language_learning_period,
          :application_learning_history, :application_skills, :application_code_background, :application_goals,
          :application_code_samples, :application_location,
          :application_location_lat, :application_location_lng,
          :application_minimum_money, :application_money
      )
    else
      {}
    end
  end

  def update_student!
    current_student.update!(student_params)
  end

  def checktime
    render :ended unless current_season.application_period?
  end

  def disallow_modifications_after_submission
    if application_draft.applied?
      redirect_to application_drafts_path, alert: 'This application has already been submitted. You cannot modify it anymore!'
    end
  end

  def ensure_max_applications
    if current_student.current_drafts.any?
      redirect_to application_drafts_path, alert: 'Sorry, you cannot lodge more than one application.'
    end
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
