class AttendancesController < ApplicationController
  # load_and_authorize_resource

  def update
    attendance.update_attributes!(attendance_params)
    redirect_to params[:return_to], notice: 'Ok, successfully updated'
  end

  def destroy
    attendance.destroy
    redirect_to params[:return_to], notice: 'Ok, the ticket was added back to the pool of available tickets'
  end

  private

    def attendance
      Attendance.find(params[:id])
    end

    def attendance_params
      params.require(:attendance).permit(:confirmed)
    end
end

