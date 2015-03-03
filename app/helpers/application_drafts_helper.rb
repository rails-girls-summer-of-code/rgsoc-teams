module ApplicationDraftsHelper

  def may_edit?(student)
    current_student && current_student.id == student.try(:id)
  end

end
