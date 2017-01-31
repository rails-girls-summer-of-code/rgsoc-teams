class Mentor::CommentsController < Mentor::BaseController
  def create
    comment = Mentor::Comment.create(create_params)
    redirect_to path_for(comment)
  end

  def update
    comment = mentor_comments.update(params[:id], update_params)
    redirect_to path_for(comment)
  end

  private

  def create_params
    params.require(:mentor_comment).
      permit(:text, :commentable_id).
      merge(user_id: current_user.id)
  end

  def update_params
    params.require(:mentor_comment).permit(:text)
  end

  def path_for(comment)
    anchor  = ActionView::RecordIdentifier.dom_id(comment)
    mentor_application_path( id: comment.commentable_id, anchor: anchor)
  end

  def mentor_comments
    Mentor::Comment.where(user: current_user)
  end
end
