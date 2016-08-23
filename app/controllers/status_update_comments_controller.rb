class StatusUpdateCommentsController < CommentsController

  def create
    comment = Comment.new(comment_params)
    status_update = comment.commentable

    if comment.save
      redirect_to status_update_path(status_update)
    else
      flash[:alert] = "O no! We can't save an empty comment. Please try again?"
      redirect_to status_update_path(status_update)
    end
  end

  private
  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :text).merge(user_id: current_user.id)
  end

end