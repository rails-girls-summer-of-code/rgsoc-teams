# frozen_string_literal: true
module ApplicationDraftsHelper
  STUDENT_FIELDS = [:name,
                    :application_age,
                    :application_gender_identification,
                    :application_diversity,
                    :application_location,
                    :application_about,
                    :application_code_background,
                    :application_skills,
                    :application_community_engagement,
                    :application_giving_back,
                    :application_language_learning_period,
                    :application_learning_history,
                    :application_code_samples,
                    :application_goals,
                    :application_motivation,
                    :application_money,
                    :application_minimum_money]

  def may_edit?(student)
    application_draft.draft? &&
      current_student &&
      current_student.id == student.try(:id)
  end

  def private_application_data(student, &block)
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

  def student_field_error_class(index, application_draft, field)
    'has-error' if application_draft.errors["student#{index}_#{field}".to_sym].present?
  end

  def student_field_error_hint(index, application_draft, field)
    application_draft.errors["student#{index}_#{field}".to_sym].join.presence
  end

  ####
  # add error counts to tabs
  ###

  def student0_tab_errors(draft)
    tab_errors(draft, STUDENT_FIELDS.map { |f| "student0_#{f}".to_sym })
  end

  def student1_tab_errors(draft)
    tab_errors(draft, STUDENT_FIELDS.map { |f| "student1_#{f}".to_sym})
  end

  def projects_tab_errors(draft)
    tab_errors(draft, ApplicationDraft::PROJECT_FIELDS)
  end

  def team_tab_errors(draft)
    tab_errors(draft, [:working_together, :deprecated_voluntary, :deprecated_voluntary_hours_per_week, :heard_about_it, :misc_info])
  end

  private

  def tab_errors(draft, fields)
    count = draft.errors.keys.map { |field| field if fields.include? field }.compact.count
    if count > 0
      "(#{count} errors)"
    end
  end

end
