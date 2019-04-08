# frozen_string_literal: true

require 'csv'

module Exporters
  class Base
    # Forward everything to a newly created instance if possible
    def self.method_missing(meth, *args, &block)
      if public_instance_methods.include? meth
        new.public_send(meth, *args, &block)
      else
        super
      end
    end

    private

    def generate(enum, *header)
      CSV.generate(col_sep: ';') do |csv|
        csv << header
        enum.each { |entry| csv << (yield entry) }
      end
    end
  end
end
