require 'spec_helper'

describe UsersController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/users')).to route_to('users#index')
    end

    it 'routes to #show' do
      expect(get('/users/1')).to route_to('users#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/users/1/edit')).to route_to('users#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post('/users')).to route_to('users#create')
    end

    it 'routes to #update' do
      expect(put('/users/1')).to route_to('users#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/users/1')).to route_to('users#destroy', id: '1')
    end

    it 'routes to #impersonate on development' do
      expect(post('/users/1/impersonate')).to route_to('users#impersonate', id: '1')
    end

    it 'routes to #stop_impersonating on development' do
      expect(post('/users/stop_impersonating')).to route_to('users#stop_impersonating')
    end
  end

  describe 'production-specific routing' do
    include_context 'with production routing'

    it 'does not route to #impersonate on production' do
      expect(post('/users/1/impersonate')).not_to be_routable
    end

    it 'does not route to #stop_impersonating on production' do
      expect(post('/users/stop_impersonating')).not_to be_routable
    end
  end
end
