require 'spec_helper'

describe RepositoriesController do
  describe 'routing' do

    it 'routes to #index' do
      get('/teams/1/repositories').should route_to('repositories#index', team_id: '1')
    end

    it 'routes to #new' do
      get('/teams/1/repositories/new').should route_to('repositories#new', team_id: '1')
    end

    it 'routes to #show' do
      get('/teams/1/repositories/1').should route_to('repositories#show', team_id: '1', id: '1')
    end

    it 'routes to #edit' do
      get('/teams/1/repositories/1/edit').should route_to('repositories#edit', team_id: '1', id: '1')
    end

    it 'routes to #create' do
      post('/teams/1/repositories').should route_to('repositories#create', team_id: '1')
    end

    it 'routes to #update' do
      put('/teams/1/repositories/1').should route_to('repositories#update', team_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      delete('/teams/1/repositories/1').should route_to('repositories#destroy', team_id: '1', id: '1')
    end

  end
end
