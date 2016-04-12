require 'spec_helper'

describe Rating::TeamsController do
  describe 'routing' do
    it 'routes to #show' do
      expect(get 'rating/teams/:id').to route_to 'rating/teams#show', id: ':id'
    end
  end
  describe 'routing helpers' do
    it 'routes rating_team_path to #show' do
      expect(get rating_team_path(':id')).to route_to 'rating/teams#show', id: ':id'
    end
  end
end
