# frozen_string_literal: true

class ProjectsController < ApplicationController
  before_action :soft_login_required, only: [:new]
  before_action :check_date!, only: [:new, :create]

  load_and_authorize_resource only: [:edit, :update, :destroy, :use_as_template]

  def new
    submitter = current_user || User.new

    @project = Project.new(
      mentor_name: submitter.name,
      mentor_github_handle: submitter.github_handle,
      mentor_email: submitter.email
    )
  end

  def show
    @project = Project.find params[:id]
  end

  def edit
    render :new
  end

  def index
    season = Season.find_by(name: params['filter']) || Season.current
    @projects = if season.current? and !season.active?
                  Project.in_current_season.not_rejected
                else
                  Project.selected(season: season)
                end
  end

  def destroy
    @project.destroy
    redirect_to projects_path, notice: 'Project was successfully deleted'
  end

  def create
    @project = Project.new(project_params)

    @project.submitter = current_user
    @project.season = Season.transition? ? Season.succ : Season.current
    respond_to do |format|
      if @project.save
        ProjectMailer.proposal(@project).deliver_later
        format.html { redirect_to receipt_project_path(@project) }
      else
        format.html { render action: :new }
      end
    end
  end

  def preview
    @project = Project.new(project_params)
    render partial: "preview"
  end

  def receipt
    @project = Project.find(params[:id])
  end

  def update
    respond_to do |format|
      if @project.update_attributes(project_params)
        format.html { redirect_to projects_path, notice: 'Project was successfully updated.' }
      else
        format.html { render action: :new }
      end
    end
  end

  def use_as_template
    @project = @project.dup
    render :new
  end

  private

  def soft_login_required
    store_location key: :previous_url_login_required
  end

  def check_date!
    redirect_to root_path, alert: 'Project submissions are closed.' and return \
      unless Season.projects_proposable?
  end

  def project_params
    params.require(:project).permit(
      :name, :mentor_name, :mentor_github_handle, :mentor_email,
      :url, :code_of_conduct, :description, :issues_and_features, :beginner_friendly,
      :taglist, :source_url, :requirements, :license
    )
  end
end
