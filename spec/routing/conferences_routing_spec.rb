require 'spec_helper'

describe ConferencesController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/conferences')).to route_to('conferences#index')
    end

    it 'routes to #show' do
      expect(get('/conferences/1')).to route_to('conferences#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/conferences/1/edit')).to route_to('conferences#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post('/conferences')).to route_to('conferences#create')
    end

    it 'routes to #update' do
      expect(put('/conferences/1')).to route_to('conferences#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/conferences/1')).to route_to('conferences#destroy', id: '1')
    end
  end
end
