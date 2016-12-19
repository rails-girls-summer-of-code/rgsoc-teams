RSpec.shared_context 'with production routing' do
  before do
    # Stub production environment and reload routes
    allow(Rails).to receive(:env).and_return('production'.inquiry)
    Rails.application.reload_routes!
  end

  after do
    # Unstub environment and reload routes
    allow(Rails).to receive(:env).and_call_original
    Rails.application.reload_routes!
  end
end
