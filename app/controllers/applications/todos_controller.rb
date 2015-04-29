class Applications::TodosController < ApplicationController
  before_action :authenticate_user!
  before_filter -> { require_role 'reviewer' }, except: [:new, :create]
  respond_to :html

  include TodoHelper

  def index
    @teams = Team.includes(:students, :applications)
  end
end
