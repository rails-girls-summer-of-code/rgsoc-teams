require 'rails_helper'
require 'error_reporting'

RSpec.describe ErrorReporting do
  describe '.call' do
    let(:raven_double) { double(capture_message: :ok, capture_exception: :ok) }

    before do
      stub_const('Raven', raven_double)
    end

    let(:error) { Class.new(Exception).new("Nope.") }
    let(:string) { "Err, what about … no?" }

    it 'will send descendants of Exception' do
      described_class.call error
      expect(raven_double).to have_received(:capture_exception)
    end

    it 'will send a simple String message' do
      described_class.call string
      expect(raven_double).to have_received(:capture_message)
    end
  end
end
