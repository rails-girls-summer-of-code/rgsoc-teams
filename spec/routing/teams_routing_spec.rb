require 'spec_helper'

describe TeamsController do
  describe 'routing' do

    it 'routes to #index' do
      get('/teams').should route_to('teams#index')
    end

    it 'routes to #new' do
      get('/teams/new').should route_to('teams#new')
    end

    it 'routes to #show' do
      get('/teams/1').should route_to('teams#show', id: '1')
    end

    it 'routes to #edit' do
      get('/teams/1/edit').should route_to('teams#edit', id: '1')
    end

    it 'routes to #create' do
      post('/teams').should route_to('teams#create')
    end

    it 'routes to #update' do
      put('/teams/1').should route_to('teams#update', id: '1')
    end

    it 'routes to #destroy' do
      delete('/teams/1').should route_to('teams#destroy', id: '1')
    end

  end
end
