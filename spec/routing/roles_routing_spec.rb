require 'spec_helper'

describe RolesController do
  describe 'routing' do

    it 'routes to #new' do
      get('/teams/1/roles/new').should route_to('roles#new', team_id: '1')
    end

    it 'routes to #create' do
      post('/teams/1/roles').should route_to('roles#create', team_id: '1')
    end

    it 'routes to #destroy' do
      delete('/teams/1/roles/1').should route_to('roles#destroy', team_id: '1', id: '1')
    end

  end
end
