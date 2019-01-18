# frozen_string_literal: true

module Supervisors
  class CommentsController < Supervisors::BaseController
    def index
      find_comments
    end

    def create
      comment = Comment.new(comment_params)
      # Now that we are saving 'checks' without comment text too, we can list them in the view with the text comments.
      # For the user, checks with or without text are treated the same (except for the mailer).
      authorize! :supervise, comment.commentable, message: "Only a team's own supervisor can comment on the team"
      if comment.save
        if comment.text.present?
          CommentMailer.email(comment).deliver_later
        end
      else
        flash[:alert] = "O no! We can't save your text. Please try again?"
      end
      redirect_to supervisors_dashboard_path
    end

    private

    def comment_params
      params.require(:comment).permit(:commentable_id, :commentable_type, :text).merge(user_id: current_user.id)
    end

    def find_comments
      team = Team.find(params[:team_id])
      @comments = team.comments.ordered.page(params[:page])
    end
  end
end
