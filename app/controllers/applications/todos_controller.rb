class Applications::TodosController < ApplicationController
  before_action :authenticate_user!
  before_action -> { require_role 'reviewer' }, except: [:new, :create]
  respond_to :html

  include TodoHelper

  def index
    @teams = Team.joins(:applications)
                 .where('"applications_count" > 0')
                 .includes(:students, :applications)
  end
end
