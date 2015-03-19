module ApplicationDraftsHelper

  def may_edit?(student)
    application_draft.state.draft? &&
      current_student &&
      current_student.id == student.try(:id)

  end

  def draft_state(draft)
    label_class = draft.state.draft? ? 'label-default' : 'label-success'
    content_tag :span, draft.state.titleize, class: "label #{label_class}"
  end

end
