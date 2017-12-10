# frozen_string_literal: true
module Reviewers
 class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action -> { require_role 'reviewer' }
    before_action :set_breadcrumbs

    def set_breadcrumbs
      @breadcrumbs = [ ['Selection', :reviewers] ]
    end
  end
end
