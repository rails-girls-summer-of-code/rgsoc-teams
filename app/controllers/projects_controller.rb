class ProjectsController < ApplicationController
  before_filter :set_team
  before_filter :set_project

  def new
    @project = @team.projects.new(name: params[:name])
  end

  def show
  end

  def create
    respond_to do |format|
      if @project.save
        format.html { redirect_to @team, notice: 'Source was successfully created.' }
        format.json { render action: :show, status: :created, location: @team }
      else
        format.html { render action: :new }
        format.json { render json: @project.errors, status: :unprocessable_entity }
      end
    end
  end


  private
  def set_team
    @team = Team.find(params[:team_id]) if params[:team_id]
  end

  def set_project
    @project = if params[:id]
        @team.projects.find(params[:id])
    else
        @team.projects.new(project_params)

  end
  end

  def project_params
    params[:project] ||= {name: params[:name]}
    params.require(:project).permit(:team_id, :name)
  end
end
