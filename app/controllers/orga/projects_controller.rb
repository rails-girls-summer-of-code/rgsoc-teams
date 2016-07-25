class Orga::ProjectsController < Orga::BaseController
  before_action :find_resource, except: [:index]

  def index
    @projects = Project.in_current_season
  end

  def accept
    if @project.accept!
      flash[:notice] = "Project has been accepted!"
    else
      flash[:alert]  = "There has been an error accepting this project."
    end
    redirect_to [:orga, :projects]
  end

  def reject
    if @project.reject!
      flash[:notice] = "Project has been rejected!"
    else
      flash[:alert]  = "There has been an error rejecting this project."
    end
    redirect_to [:orga, :projects]
  end

  def lock
    @project.update_attribute :comments_locked, true
    redirect_to [:orga, :projects], notice: "Comments for '#{@project.name}' are now locked."
  end

  def unlock
    @project.update_attribute :comments_locked, false
    redirect_to [:orga, :projects], notice: "Comments for '#{@project.name}' are now unlocked."
  end

  private

  def find_resource
    @project ||= Project.find(params[:id])
  end
end
