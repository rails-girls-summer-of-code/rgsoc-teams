class AttendancesController < ApplicationController

  def update
    attendance.update_attributes!(attendance_params)
    redirect_back fallback_location: user_path(current_user), notice: 'Ok, successfully updated'
  end

  def destroy
    attendance.destroy
    redirect_back fallback_location: user_path(current_user), notice: 'Ok, the ticket was added back to the pool of available tickets'
  end

  private

    def attendance
      current_user.student_team.attendances.find(params[:id])
    end

    def attendance_params
      params.require(:attendance).permit(:confirmed)
    end

end
