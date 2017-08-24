class ConferenceAttendancesController < ApplicationController

  def update
    @conference_attendance = ConferenceAttendance.find(params[:id])
    @team = @conference_attendance.team

    if @conference_attendance.update_attributes(attendance_params)
      redirect_to @team, notice: 'Your attendance was successfully recorded.'
    else
      render json: @conference_attendance.errors, status: :unprocessable_entity
    end
  end

  private
    def attendance_params
      params.permit(:attendance)
    end
end
