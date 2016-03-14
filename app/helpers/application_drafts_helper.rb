module ApplicationDraftsHelper

  def may_edit?(student)
    application_draft.draft? &&
      current_student &&
      current_student.id == student.try(:id)
  end

  def private_application_data(application_draft, student, &block)
    block ||= Proc.new {}
    header  = Proc.new do
      content_tag :h4, "This section is hidden from the rest of your team"
    end

    content_tag :div, class: 'bs-callout bs-callout-warning' do
      if student == current_user
        capture(&header) + capture(&block)
      else
        "This section is private."
      end
    end
  end

  def draft_state(draft)
    label_class = draft.draft? ? 'label-default' : 'label-success'
    content_tag :span, draft.state.titleize, class: "label #{label_class}"
  end

end
