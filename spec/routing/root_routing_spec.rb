require 'spec_helper'

describe 'root routing' do
  it 'routes to users#index' do
    expect(get('/')).to route_to('users#index')
  end
end
