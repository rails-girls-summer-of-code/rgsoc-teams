class Supervisor::CommentsController < Supervisor::BaseController

  def create
    comment = Comment.new(comment_params)

    if comment.save
      CommentMailer.email(comment).deliver_later
      redirect_to supervisor_dashboard_path
    else
      flash[:alert] = "O no! We can't save your comment. Please try again?"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:team_id, :text).merge(user_id: current_user.id)
  end
end