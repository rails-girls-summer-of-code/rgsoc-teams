class Mentor::ApplicationsController < Mentor::BaseController
  def index
    @applications = applications
  end

  def show
    @application = application
  end

  private

  def projects
    Project.where(submitter: current_user)
  end

  def application
    Mentor::Application.find(id: params[:id], projects: projects, choice: params[:choice])
  end

  def applications
    first_choice + second_choice
  end

  def first_choice
    Mentor::Application.all_for(projects: projects, choice: 1)
  end

  def second_choice
    Mentor::Application.all_for(projects: projects, choice: 2)
  end
end
