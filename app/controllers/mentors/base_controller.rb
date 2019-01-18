# frozen_string_literal: true

module Mentors
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action -> { require_project_maintainer }

    private

    def require_project_maintainer
      redirect_to '/', alert: "Project maintainer required" unless current_user.project_maintainer?
    end
  end
end
