class Orga::ProjectsController < Orga::BaseController
  before_action :find_resource, only: [:accept, :reject]

  def index
    @projects = Project.current
  end

  def accept
    if @project.accept!
      flash[:notice] = "Project has been accepted!"
    else
      flash[:alert]  = "There has been an error accepting this project."
    end
    redirect_to [:orga, @project]
  end

  def reject
    if @project.reject!
      flash[:notice] = "Project has been rejected!"
    else
      flash[:alert]  = "There has been an error rejecting this project."
    end
    redirect_to [:orga, @project]
  end

  private

  def find_resource
    @project ||= Project.find(params[:id])
  end
end
