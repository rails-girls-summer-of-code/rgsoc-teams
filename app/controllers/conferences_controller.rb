require 'csv'
class ConferencesController < ApplicationController
 before_action :redirect, except: [:index, :show]

  def new
  end
 
  def index
    @conferences = conferences
  end
 
  def show
    @conference = Conference.find(params[:id])
  end

  def redirect
    redirect_to orga_conferences_path
  end

  private
 
  def conferences
    Conference.ordered(sort_params).in_current_season
  end

  def sort_params
    {
      order: %w(name gid starts_on city country region).include?(params[:sort]) ? params[:sort] : nil,
      direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
    }
  end
end
