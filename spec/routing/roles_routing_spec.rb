require 'spec_helper'

describe RolesController do
  describe 'routing' do
    it 'routes to #new' do
      expect(get('/teams/1/roles/new')).to route_to('roles#new', team_id: '1')
    end

    it 'routes to #create' do
      expect(post('/teams/1/roles')).to route_to('roles#create', team_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/teams/1/roles/1')).to route_to('roles#destroy', team_id: '1', id: '1')
    end
  end
end
