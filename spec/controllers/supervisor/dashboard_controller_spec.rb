require 'spec_helper'

RSpec.describe Supervisor::DashboardController, type: :controller do
  render_views
  describe 'routes for dashboard', type: :routing do
    it 'routes /dashboard to the dashboard controller' do
      expect(get('/supervisor/dashboard')).to route_to('supervisor/dashboard#index')
    end
    it 'routes /supervisor to the dashboard controller' do
      expect(get('/supervisor')).to route_to('supervisor/dashboard#index')
    end
  end
end
