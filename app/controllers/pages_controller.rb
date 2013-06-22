class PagesController < ActionController::Base
  LAYOUTS = {
    help: 'help'
  }

  def show
    render params[:page], layout: LAYOUTS[params[:page].to_sym] || 'application'
  end
end
