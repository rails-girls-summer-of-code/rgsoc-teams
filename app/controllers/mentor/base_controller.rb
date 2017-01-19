class Mentor::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_role 'mentor' }
end
