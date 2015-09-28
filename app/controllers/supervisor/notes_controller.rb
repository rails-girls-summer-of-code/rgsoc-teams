class Supervisor::NotesController < Supervisor::BaseController

  def index
  end

  def show
  end

  def edit
  end

  def update
    @notepad = Note.find_by(id: @current_user.id)
      if @notepad.update(notepad_params)
          redirect_to supervisor_dashboard_path
      else
        #what to do here?
      end
  end


  private

    def notepad_params
      params.require(:note).permit(:body).merge(id: @current_user.id)
    end

end