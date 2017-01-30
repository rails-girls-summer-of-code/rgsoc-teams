require 'spec_helper'

describe Orga::DashboardController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get 'orga/').to route_to 'orga/dashboard#index'
    end
  end

  describe 'routing helpers' do
    it 'routes get orga_dashboard_path to #index' do
      expect(get orga_dashboard_path).to route_to 'orga/dashboard#index'
    end
  end
end
