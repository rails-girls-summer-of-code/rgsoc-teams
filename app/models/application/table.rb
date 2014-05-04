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
        (display_cs_students?  || !application.cs_student?) and
        (display_remote_teams? || !application.remote_team?) and
        (display_in_teams?     || !application.in_team?) and
        (display_duplicates?   || !application.duplicate?)
      end

      [:cs_students, :remote_teams, :in_teams, :duplicates].each do |flag|
        define_method(:"display_#{flag}?") do
          options.key?(:"display_#{flag}") && options[:"display_#{flag}"]
        end
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

