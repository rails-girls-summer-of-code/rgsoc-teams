class Application
  class Table
    class Row
      attr_reader :names, :application, :options

      def initialize(names, application, options)
        @names = names
        @application = application
        @options = options
      end

      def total_picks
        application.total_picks
      end

      def total_rating(column, options)
        application.total_rating(column, options)
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
        (cs_students?  || !application.cs_student?) and
        (remote_teams? || !application.remote_team?) and
        (in_teams?     || !application.in_team?) and
        (duplicates?   || !application.duplicate?)
      end

      [:cs_students, :remote_teams, :in_teams, :duplicates].each do |flag|
        define_method(:"#{flag}?") do
          options.key?(flag) && options[flag]
        end
      end
    end

    attr_reader :names, :rows, :order, :options

    def initialize(names, applications, options)
      @names = names
      @options = options
      @order = options[:order].try(:to_sym) || :id
      @rows = applications.map { |application| Row.new(names, application, options) }
      @rows = rows.select { |row| row.display? }
      @rows = sort(rows)
    end

    def sort(rows)
      rows.sort_by do |row|
        if options[:order] == 'picks'
          row.total_picks
        else
          row.total_rating(order, options)
        end
      end.reverse
    end
  end
end

