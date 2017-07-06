module ProjectsHelper

  def project_status(project)
    label_class = case project.aasm_state
                  when 'proposed'
                    'label-default'
                  when 'accepted'
                    'label-success'
                  when 'rejected'
                    'label-danger'
                  when 'pending'
                    'label-warning'
                  end
    content_tag :span, project.aasm_state, class: "label #{label_class}"
  end

  def project_tags(project)
    project.tags.map{ |t| "<span class='label label-default'>#{t}</span>" }.join(' ').html_safe
  end

end
