require 'rails_helper'

RSpec.describe JoinController, type: :routing do
  describe 'routing' do
    it 'routes to #new' do
      expect(get('/teams/1/join/new')).to route_to('join#new', team_id: '1')
    end

    it 'routes to #create' do
      expect(post('/teams/1/join')).to route_to('join#create', team_id: '1')
    end
  end
end
