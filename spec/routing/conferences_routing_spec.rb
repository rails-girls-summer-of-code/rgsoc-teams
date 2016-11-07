require 'spec_helper'

describe ConferencesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/conferences')).to route_to('conferences#index')
    end

    it 'routes to #show' do
      expect(get('/conferences/1')).to route_to('conferences#show', id: '1')
    end
  end
end
