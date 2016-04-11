class Rating::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_role 'reviewer' }
end
