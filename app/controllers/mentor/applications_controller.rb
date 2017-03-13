class Mentor::ApplicationsController < Mentor::BaseController
  before_action :application, only: [:show, :signoff, :fav]

  def index
    @applications = applications
  end

  def show
    @comment = application.find_or_initialize_comment_by(current_user)
  end

  def signoff
    app = Application.find(@application.id)
    msg = if app.signed_off?
            app.update!(signed_off_at: nil, signatory: nil)
            "You revoked your sign-off of #{@application.team_name}'s application."
          else
            app.sign_off! as: current_user
            "Successfully signed-off #{@application.team_name}'s application."
          end
    redirect_to url_for(action: :index), notice: msg
  end

  def fav
    app = Application.find(@application.id).tap { |a| a.toggle! :mentor_fav }
    msg = if app.mentor_fav?
            "Successfully fav'ed #{@application.team_name}'s application."
          else
            "Revoked your preference for #{@application.team_name}'s application."
          end
    redirect_to url_for(action: :index), notice: msg
  end

  private

  def projects
    Project.
      in_current_season.
      accepted.
      where(submitter: current_user)
  end

  def application
    @application ||= Mentor::Application.find(id: params[:id], projects: projects)
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
