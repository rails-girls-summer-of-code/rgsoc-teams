require 'spec_helper'


describe 'routes for dashboard', type: :routing do
  it 'routes /dashboard to the dashboard controller' do
    expect(get('/supervisor/dashboard')).to route_to('supervisor/dashboard#index')
  end
end