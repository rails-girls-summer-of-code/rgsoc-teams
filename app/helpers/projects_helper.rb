module ProjectsHelper

  def project_status(project)
    label_class = case project.aasm_state
                  when 'proposed'
                    'label-default'
                  when 'accepted'
                    'label-success'
                  when 'rejected'
                    'label-danger'
                  end
    content_tag :span, project.aasm_state, class: "label #{label_class}"
  end
end
