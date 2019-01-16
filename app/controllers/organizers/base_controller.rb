# frozen_string_literal: true

module Organizers
  class BaseController < ApplicationController
    before_action :must_be_admin
    before_action :set_breadcrumbs

    protected

    def must_be_admin
      redirect_to root_path, alert: 'Access for admins only.' unless current_user.try(:admin?)
    end

    def set_breadcrumbs
      @breadcrumbs = [['Orga', :dashboard]]
    end
  end
end
