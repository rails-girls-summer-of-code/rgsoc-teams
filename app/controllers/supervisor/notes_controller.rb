class Supervisor::NotesController < Supervisor::BaseController

  def update
    @notepad = @current_user.notepad
    @notepad.update(notepad_params)
    redirect_to supervisor_dashboard_path
  end

  private

    def notepad_params
      params.require(:note).permit(:body)
    end

end