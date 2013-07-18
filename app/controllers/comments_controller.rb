class CommentsController < ApplicationController
  def create
    comment = Comment.create(comment_params)
    CommentMailer.email(comment).deliver
    redirect_to comment.team
  end

  private

    def comment_params
      params.require(:comment).permit(:team_id, :text).merge(user_id: current_user.id)
    end
end
