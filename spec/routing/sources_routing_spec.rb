require 'spec_helper'

RSpec.describe SourcesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/sources')).to route_to('sources#index')
      expect(get('/teams/1/sources')).to route_to('sources#index', team_id: '1')
    end

    it 'routes to #new' do
      expect(get('/teams/1/sources/new')).to route_to('sources#new', team_id: '1')
    end

    it 'routes to #show' do
      expect(get('/teams/1/sources/1')).to route_to('sources#show', team_id: '1', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/teams/1/sources/1/edit')).to route_to('sources#edit', team_id: '1', id: '1')
    end

    it 'routes to #create' do
      expect(post('/teams/1/sources')).to route_to('sources#create', team_id: '1')
    end

    it 'routes to #update' do
      expect(put('/teams/1/sources/1')).to route_to('sources#update', team_id: '1', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/teams/1/sources/1')).to route_to('sources#destroy', team_id: '1', id: '1')
    end
  end
end
