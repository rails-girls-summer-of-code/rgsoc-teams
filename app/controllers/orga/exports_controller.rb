# eager load export classes in development
Dir[Rails.root.join('app/exporters/*.rb')].each { |f| require f }

class Orga::ExportsController < Orga::BaseController
  helper_method :available_exports

  def index
  end

  def create
    exporter, meth = params[:export].to_s.split('#', 2)
    csv = exporter.constantize.public_send(meth)
    filename = [exporter.parameterize, meth].join('_') + '.csv'
    send_data csv, filename: filename
  end

  protected

  # Finds available exports when they are defined in the
  # Exports namespace
  def available_exports
    @exports ||= (Exporters.constants - [:Base]).map do |exp|
      klass = Exporters.const_get(exp)
      (klass.public_instance_methods - Object.public_instance_methods).map{|m| "Exporters::#{exp}##{m}" }
    end.flatten
  end

end
