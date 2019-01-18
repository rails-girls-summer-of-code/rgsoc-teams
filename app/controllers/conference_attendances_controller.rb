# frozen_string_literal: true

class ConferenceAttendancesController < ApplicationController
  def update
    @conference_attendance = ConferenceAttendance.find(params[:id])

    if @conference_attendance.update_attributes(attendance_params)
      redirect_to @conference_attendance.team, notice: 'Your attendance was successfully recorded.'
    else
      render json: @conference_attendance.errors, status: :unprocessable_entity
    end
  end

  private

  def attendance_params
    params.require(:conference_attendance).permit(:attendance)
  end
end
