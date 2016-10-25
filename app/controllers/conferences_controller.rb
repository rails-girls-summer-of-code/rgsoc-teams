class ConferencesController < ApplicationController
 before_action :redirect, except: [:index, :show]

  def new
  end

  def redirect
    redirect_to orga_conferences_path
  end

  private

    def conferences
      @conferences ||= Conference.ordered(sort_params).in_current_season
    end
    helper_method :conferences

    def conference
       @conference ||= params[:id] ? Conference.find(params[:id]) : Conference.new(conference_params)
    end
    helper_method :conference

    def conference_params
     params[:conference] ? params.require(:conference).permit(
         :name, :url, :location, :twitter, :tickets, :flights, :accomodation,
         :'starts_on(1i)', :'starts_on(2i)', :'starts_on(3i)', :round,
         :'ends_on(1i)', :'ends_on(2i)', :'ends_on(3i)', :lightningtalkslots,
         attendances_attributes: [:id, :github_handle, :_destroy]
     ) : {}
    end

    def sort_params
      {
        order: %w(name location starts_on).include?(params[:sort]) ? params[:sort] : nil,
        direction: %w(asc desc).include?(params[:direction]) ? params[:direction] : nil
      }
    end
end
