# frozen_string_literal: true
class Supervisor::NotesController < Supervisor::BaseController

  def update
    find_notepad
    @notepad.update!(notepad_params)
    redirect_to supervisor_dashboard_path
  end

  private

  def find_notepad
    @notepad = Note.notepad(current_user)
  end

  def notepad_params
    params.require(:note).permit(:body)
  end

end
