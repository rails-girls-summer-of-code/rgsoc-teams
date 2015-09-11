class Supervisor::CommentsController < Supervisor::BaseController
  before_filter :get_team, except: :create

  def index
    @comments = @team.comments
  end

  def create
    comment = Comment.new(comment_params)
    # Now that we are saving also 'checks' without comment text, we can list them in the view with the text comments.
    # For the user, checks with or without text are treated the same (except for the mailer).
    if comment.save
      if comment.text.present?
      CommentMailer.email(comment).deliver_later
      end
    else
        flash[:alert] = "O no! We can't save your comment. Please try again?"
    end
    redirect_to supervisor_dashboard_path
  end


  private

  def comment_params
    params.require(:comment).permit(:team_id, :text).merge(user_id: current_user.id)
  end

  def get_team
      @team = Team.find(params[:team_id])
  end
end