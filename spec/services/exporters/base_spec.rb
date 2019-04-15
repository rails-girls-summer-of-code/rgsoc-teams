require 'rails_helper'

RSpec.describe Exporters::Base do
  def exporter
    @exporter ||= Class.new(Exporters::Base) do
      def my_export
        :called
      end
    end
  end

  it 'forwards class-level methods to an instance' do
    expect_any_instance_of(exporter).to receive(:my_export).and_call_original
    expect(exporter.my_export).to eql :called
  end
end
