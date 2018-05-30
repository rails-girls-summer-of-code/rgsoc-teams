require 'rails_helper'

RSpec.describe Organizers::DashboardController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get 'organizers/').to route_to 'organizers/dashboard#index'
    end
  end

  describe 'routing helpers' do
    it 'routes get organizers_dashboard_path to #index' do
      expect(get organizers_dashboard_path).to route_to 'organizers/dashboard#index'
    end
  end
end
