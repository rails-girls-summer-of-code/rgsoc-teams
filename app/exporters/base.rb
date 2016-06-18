require 'csv'

module Exporters
  class Base
    class << self

      private

      def generate(enum, *header)
        CSV.generate(col_sep: ';') do |csv|
          csv << header
          enum.each { |entry| csv << (yield entry) }
        end
      end

    end

  end
end
