class CommentsController < ApplicationController
  def create
    comment = Comment.create(comment_params)
    CommentMailer.email(comment).deliver unless comment.for_application?
    redirect_to comment.team || comment.application
  end

  private

  def comment_params
    params.require(:comment).permit(:team_id, :text, :application_id).merge(user_id: current_user.id)
  end
end
