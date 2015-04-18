class Application
  class Table
    class Row
      attr_reader :names, :application, :options

      def initialize(names, application, options)
        @names = names
        @application = application
        @options = options
      end

      def id
        application.id
      end

      def location
        application.country
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
      case order = options[:order].to_sym
      when :id, :location
        rows.sort_by(&order)
      when :picks
        sort_by_picks(rows).reverse
      when
        rows.sort_by { |row| row.total_rating(order, options) }.reverse
      end
    end

    def sort_by_picks(rows)
      rows.sort do |lft, rgt|
        if lft.total_picks == rgt.total_picks
          result = lft.total_rating(:mean, options) <=> rgt.total_rating(:mean, options)
          result
        else
          lft.total_picks <=> rgt.total_picks
        end
      end
    end
  end
end

