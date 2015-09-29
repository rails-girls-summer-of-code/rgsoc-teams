class Note < ActiveRecord::Base

  def self.notepad(current_user)
    @notepad ||= Note.find_or_create_by(user_id: current_user.id)
  end

end