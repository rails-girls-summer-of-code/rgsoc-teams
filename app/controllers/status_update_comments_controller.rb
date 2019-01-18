# frozen_string_literal: true

class StatusUpdateCommentsController < CommentsController
  def create
    comment = Comment.new(comment_params)
    status_update = comment.commentable

    if comment.text.present?
      comment.save
    else
      flash[:alert] = "O no! We can't save an empty comment. Please try again?"
    end
    redirect_to status_update_path(status_update)
  end

  private

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :text).merge(user_id: current_user.id)
  end
end
