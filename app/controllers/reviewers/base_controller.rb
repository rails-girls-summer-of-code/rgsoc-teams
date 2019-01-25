# frozen_string_literal: true

module Reviewers
  class BaseController < ApplicationController
    DASHBOARD_PATH = %i(reviewers dashboard).freeze

    before_action :authenticate_user!
    before_action -> { require_role 'reviewer' }
    before_action :set_breadcrumbs

    def set_breadcrumbs
      @breadcrumbs = [['Rating', DASHBOARD_PATH]]
    end
  end
end
