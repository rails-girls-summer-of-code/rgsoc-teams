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
        p options
        p display_cs_students?
        (display_cs_students?  || !application.cs_student?) and
        # (display_remote_teams? || !application.remote_team?) and
        # (display_duplicate?    || !application.duplicate?)
        true
      end

      def display_remote_teams?
        options.key?(:display_remote_teams) && options[:display_remote_teams]
      end

      def display_cs_students?
        options.key?(:display_cs_students) && options[:display_cs_students]
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

