require 'spec_helper'

RSpec.describe Rating::RatingsController, type: :routing do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get 'rating/ratings').not_to be_routable
    end

    it 'does not route to #new' do
      expect(get 'rating/ratings/new').not_to be_routable
    end

    it 'does not route to #show' do
      expect(get 'rating/ratings/1').not_to be_routable
    end

    it 'does not route to #edit' do
      expect(get 'rating/ratings/:id/edit').not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete 'rating/ratings/:id').not_to be_routable
    end

    it 'routes to #create' do
      expect(post 'rating/ratings').to route_to 'rating/ratings#create'
    end

    it 'routes to #update' do
      expect(put 'rating/ratings/:id').to route_to 'rating/ratings#update', id: ':id'
    end
  end
end
