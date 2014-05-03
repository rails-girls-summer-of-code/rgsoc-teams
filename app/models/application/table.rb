class Application
  class Table
    class Row
      attr_reader :names, :application, :options

      def initialize(names, application, options)
        @names = names
        @application = application
        @options = options
      end

      def ratings
        @ratings ||= names.map do |name|
          ratings = application.ratings
          ratings = ratings.excluding(options[:exclude]) unless options[:exclude].blank?
          rating = ratings.find { |rating| rating.user.name == name }
          rating || Hashr.new(value: '-')
        end
      end

      def display?
        display_super_students? || !application.super_student?
      end

      def display_super_students?
        options.key?(:display_super_students) && options[:display_super_students]
      end
    end

    attr_reader :names, :rows

    def initialize(names, applications, options)
      @names = names
      @rows = applications.map { |application| Row.new(names, application, options) }
      @rows = rows.select { |row| row.display? }
    end
  end
end

