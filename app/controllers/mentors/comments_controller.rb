# frozen_string_literal: true

module Mentors
  class CommentsController < Mentors::BaseController
    def create
      comment = Mentor::Comment.create(create_params)
      redirect_to path_for(comment)
    end

    def update
      mentor_comment.update(update_params)
      redirect_to path_for(mentor_comment)
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
      anchor = ActionView::RecordIdentifier.dom_id(comment)
      mentors_application_path(id: comment.commentable_id, anchor: anchor)
    end

    def mentor_comment
      Mentor::Comment.find_by!(id: params[:id], user: current_user)
    end
  end
end
