class PagesController < ActionController::Base
  def show
    render params[:page], layout: 'application'
  end
end
