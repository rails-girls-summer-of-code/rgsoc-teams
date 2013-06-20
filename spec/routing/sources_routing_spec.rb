require 'spec_helper'

describe SourcesController do
  describe 'routing' do

    it 'routes to #index' do
      get('/teams/1/sources').should route_to('sources#index', team_id: '1')
    end

    it 'routes to #new' do
      get('/teams/1/sources/new').should route_to('sources#new', team_id: '1')
    end

    it 'routes to #show' do
      get('/teams/1/sources/1').should route_to('sources#show', team_id: '1', id: '1')
    end

    it 'routes to #edit' do
      get('/teams/1/sources/1/edit').should route_to('sources#edit', team_id: '1', id: '1')
    end

    it 'routes to #create' do
      post('/teams/1/sources').should route_to('sources#create', team_id: '1')
    end

    it 'routes to #update' do
      put('/teams/1/sources/1').should route_to('sources#update', team_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      delete('/teams/1/sources/1').should route_to('sources#destroy', team_id: '1', id: '1')
    end

  end
end
