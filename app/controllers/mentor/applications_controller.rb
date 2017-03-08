class Mentor::ApplicationsController < Mentor::BaseController
  def index
    @applications = applications
  end

  def show
    @application = application
    @comment     = application.find_or_initialize_comment_by(current_user)
  end

  def signoff
    Application.find(application.id).sign_off! as: current_user
    redirect_to action: :index
  end

  private

  def projects
    Project.
      in_current_season.
      accepted.
      where(submitter: current_user)
  end

  def application
    Mentor::Application.find(id: params[:id], projects: projects)
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
