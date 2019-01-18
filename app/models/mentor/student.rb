# frozen_string_literal: true

module Mentor
  class Student
    include ActiveModel::Model

    APPLICATION_KEYS = [
      '_application_coding_level',
      '_application_name',
      '_application_code_samples',
      '_application_learning_history',
      '_application_language_learning_period',
      '_application_skills'

    ]

    attr_accessor :coding_level, :code_samples,
                  :learning_history, :language_learning_period,
                  :skills, :name
  end
end
