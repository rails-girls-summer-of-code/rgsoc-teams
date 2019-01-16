# frozen_string_literal: true

module Mentors
  class ApplicationsController < Mentors::BaseController
    before_action :application, only: [:show, :signoff, :fav]

    def index
      @applications = applications
    end

    def show
      @comment = application.find_or_initialize_comment_by(current_user)
    end

    def signoff
      msg = if application.signed_off?
              application.revoke_sign_off!
              "You revoked your sign-off of #{application.team_name}'s application."
            else
              application.sign_off! as: current_user
              "Successfully signed-off #{application.team_name}'s application."
            end
      redirect_to url_for(action: :index), notice: msg
    end

    def fav
      msg = if application.mentor_fav?
              application.revoke_mentor_fav!
              "Revoked your preference for #{application.team_name}'s application."
            else
              application.mentor_fav!
              "Successfully fav'ed #{application.team_name}'s application."
            end
      redirect_to url_for(action: :index), notice: msg
    end

    private

    def projects
      @projects ||= Project
        .in_current_season
        .accepted
        .joins(:maintainerships)
        .where("maintainerships.user_id" => current_user.id)
    end

    def application
      @application ||= Mentor::Application.find(id: params[:id], projects: projects)
    end

    def applications
      @applications ||= first_choice + second_choice
    end

    def comments
      @comments ||= Mentor::Comment.where(commentable_id: applications.map(&:id), user: current_user)
    end

    def comment_for(application)
      comments.find { |comment| comment.commentable_id == application.id }
    end
    helper_method :comment_for

    def first_choice
      Mentor::Application.all_for(projects: projects, choice: 1)
    end

    def second_choice
      Mentor::Application.all_for(projects: projects, choice: 2)
    end
  end
end
