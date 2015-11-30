class ProjectsController < ApplicationController

  before_action :login_required, only: [:new]

  def new
    @project = Project.new
  end

  def index
    @projects = Project.all
  end

  def create
    @project = Project.new(project_params)

    @project.submitter_id = current_user.id
    respond_to do |format|
      if @project.save
        format.html { redirect_to projects_path, notice: 'Project was successfully submitted.' }
      else
        format.html { render action: :new }
      end
    end
  end

  private

  def project_params
    params.require(:project).permit(
      :name, :mentor_name, :mentor_github_handle, :mentor_email,
      :url, :description, :issues_and_features, :beginner_friendly
    )
  end
end
