# frozen_string_literal: true

class CalendarController < ApplicationController
  def index
  end

  def events
    respond_to do |format|
      format.json { render json: Conference.all }
    end
  end
end
