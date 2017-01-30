class Orga::BaseController < ApplicationController
  before_action :must_be_admin

  protected

  def must_be_admin
    redirect_to root_path, alert: 'Access for admins only.' unless current_user.try(:admin?)
  end
end
