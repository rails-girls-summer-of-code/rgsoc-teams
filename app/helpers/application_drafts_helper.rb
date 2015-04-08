module ApplicationDraftsHelper

  def may_edit?(student)
    application_draft.draft? &&
      current_student &&
      current_student.id == student.try(:id)

  end

  def draft_state(draft)
    label_class = draft.draft? ? 'label-default' : 'label-success'
    content_tag :span, draft.state.titleize, class: "label #{label_class}"
  end

end
