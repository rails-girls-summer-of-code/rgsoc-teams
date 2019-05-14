# frozen_string_literal: true

class CommentsController < ApplicationController
  # This controller manages the comments on applications and projects.
  # Supervisor's comments on their teams are managed by the supervisors/comments-controller
  # We only allow comments with text (others do not make sense here)

  # this might be overwritten by subclasses to prepend to the redirect path:
  PATH_PARENTS = []

  def create
    @comment = Comment.new(comment_params)

    if @comment.text.present? && @comment.save
      anchor = ActionView::RecordIdentifier.dom_id(@comment)
    else
      flash[:alert] = "Oh no! We can't save your comment. Please try again?"
    end

    @new_comment = self.class::PATH_PARENTS + [Comment.new(commentable: @comment.commentable)]

    respond_to do |format|
      format.html { redirect_to commentable_path(@comment.commentable, anchor || nil) }
      format.js {}
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:commentable_id, :commentable_type, :text).merge(user_id: current_user.id)
  end

  def commentable_path(commentable, anchor)
    self.class::PATH_PARENTS + [commentable, anchor: anchor]
  end
end
