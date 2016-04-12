class CommentsController < ApplicationController

  # This controller manages the comments on applications and projects.
  # Supervisor's comments on their teams are managed by the supervisor/comments-controller
  # We only allow comments with text (others do not make sense here)

  def create
    comment = Comment.new(comment_params)

    if (comment.text.present? && comment.save)
      anchor = ActionView::RecordIdentifier.dom_id(comment)
    else
      flash[:alert] = "Oh no! We can't save your comment. Please try again?"
    end
    redirect_to commentable_path(comment.commentable, anchor || nil)
  end

  private

  def comment_params
    params.require(:comment).permit(:team_id, :text, :application_id, :project_id).merge(user_id: current_user.id)
  end

  def commentable_path(commentable, anchor)
    case commentable
    when Application
      [:rating, commentable, anchor: anchor]
    else
      [commentable, anchor: anchor]
    end
  end
end
