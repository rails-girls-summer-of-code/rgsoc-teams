# frozen_string_literal: true

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
    project.tags.map { |t| "<span class='label label-default'>#{t}</span>" }.join(' ').html_safe
  end

  # @return [Array<String>] a list of years we have projects for, most recent first.
  def project_years
    (Season.joins(:projects).distinct.pluck(:name) + [Date.today.year.to_s]).uniq.sort.reverse
  end
end
