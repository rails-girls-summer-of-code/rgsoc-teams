class CalendarController < ApplicationController
  def index
  end

  def get_events
  	render json:Conference.all()
  end
end
