module Conferencable
    extend ActiveSupport::Concern
    
    def index
      @conferences = conferences
    end

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
