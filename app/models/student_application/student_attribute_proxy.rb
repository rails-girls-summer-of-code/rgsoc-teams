# frozen_string_literal: true

module StudentApplication
  class StudentAttributeProxy
    attr_reader :match, :application_draft

    def initialize(method, application_draft)
      @application_draft = application_draft
      @match = /^student([01])_(.*)$/.match(method.to_s)
    end

    def attribute(*args)
      students[index]&.send(field, *args)
    end

    def matches?
      match.present?
    end

    def students
      application_draft.try(:students) || []
    end

    def index
      match[1].to_i
    end

    def field
      match[2]
    end
  end
end
