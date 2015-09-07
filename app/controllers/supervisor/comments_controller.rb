class Supervisor::CommentsController < Supervisor::BaseController

  def create
    comment = Comment.new(comment_params)

    if comment.save
    #TODO move mailer thingies below into separate application comment mailer/controller
    CommentMailer.email(comment).deliver_later unless comment.for_application?
    #redirect_to comment.team || comment.application
    end
    redirect_to supervisor_dashboard_path
  end

  private

  def comment_params
    params.require(:comment).permit(:team_id, :text, :application_id).merge(user_id: current_user.id)
  end
end