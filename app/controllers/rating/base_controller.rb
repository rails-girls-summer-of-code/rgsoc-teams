class Rating::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_role 'reviewer' }
  before_action :set_breadcrumbs

  def set_breadcrumbs
    @breadcrumbs = [ ['Rating', :rating] ]
  end
end
