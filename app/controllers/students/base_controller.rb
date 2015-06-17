class Students::BaseController < ApplicationController
  before_action :must_be_student

  protected

  def must_be_student
    # redirect_to root_path, alert: 'You must be listed as a student for the current RGSoC season' unless current_user.try(:student?)
  end

end

