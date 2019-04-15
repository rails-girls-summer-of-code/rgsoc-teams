# frozen_string_literal: true

# eager load export classes in development
Dir[Rails.root.join('app/services/exporters/*.rb')].each { |f| require f }

module Organizers
  class ExportsController < Organizers::BaseController
    helper_method :available_exports

    def index
    end

    def create
      if available_exports.include?(params[:export])
        exporter, meth = params[:export].to_s.split('#', 2)
        csv = exporter.constantize.public_send(meth)
        filename = [exporter.parameterize, meth].join('_') + '.csv'
        send_data csv, filename: filename
      else
        render plain: 'Exporter not found', status: :not_found
      end
    end

    protected

    # Finds available exports when they are defined in the
    # Exports namespace
    def available_exports
      @exports ||= (Exporters.constants - [:Base]).map do |exp|
        klass = Exporters.const_get(exp)
        (klass.public_instance_methods - Object.public_instance_methods).map { |m| "Exporters::#{exp}##{m}" }
      end.flatten
    end

    def set_breadcrumbs
      super
      @breadcrumbs << ['Exports', :exports]
    end
  end
end
