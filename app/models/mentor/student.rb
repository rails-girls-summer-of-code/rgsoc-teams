module Mentor
  class Student
    include ActiveModel::Model

    APPLICATION_KEYS = [
      '_application_coding_level',
      '_application_code_samples',
      '_application_learning_history',
      '_application_skills',
      '_application_code_background'
    ]

    attr_accessor :coding_level, :code_samples
    attr_accessor :learning_history, :code_background
    attr_accessor :skills
  end
end
