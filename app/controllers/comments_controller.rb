class CommentsController < ApplicationController

  # This controller manages the comments on applications only.
  # Supervisor's comments on their teams are managed by the supervisor/comments-controller

  def create
    comment = Comment.new(comment_params)

    if comment.save
      redirect_to comment.commentable
    else
      flash[:alert] = "O no! We can't save your comment. Please try again?"
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:team_id, :text, :application_id).merge(user_id: current_user.id)
  end
end
