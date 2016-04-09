require 'spec_helper'

describe RatingsController do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get '/ratings').not_to be_routable
    end

    it 'does not route to #new' do
      expect(get '/ratings/new').not_to be_routable
    end

    it 'does not route to #show' do
      expect(get '/ratings/1').not_to be_routable
    end

    it 'does not route to #edit' do
      expect(get '/ratings/:id/edit').not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete '/ratings/:id').not_to be_routable
    end

    it 'routes to #create' do
      expect(post '/ratings').to route_to 'ratings#create'
    end

    it 'routes to #update' do
      expect(put '/ratings/:id').to route_to 'ratings#update', id: ':id'
    end
  end
end
