class Mentor::ApplicationsController < Mentor::BaseController
  def index
    @applications = applications
  end

  def show

  end

  private

  def projects
    Project.where(submitter: current_user)
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
