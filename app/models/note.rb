# frozen_string_literal: true

class Note < ApplicationRecord
  def self.notepad(user)
    Note.find_or_create_by(user_id: user.id)
  end
end
