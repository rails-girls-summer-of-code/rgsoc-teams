require 'rails_helper'

RSpec.describe Reviewers::RatingsController, type: :routing do
  describe 'routing' do
    it 'does not route to #index' do
      expect(get 'reviewers/ratings').not_to be_routable
    end

    it 'does not route to #new' do
      expect(get 'reviewers/ratings/new').not_to be_routable
    end

    it 'does not route to #show' do
      expect(get 'reviewers/ratings/1').not_to be_routable
    end

    it 'does not route to #edit' do
      expect(get 'reviewers/ratings/:id/edit').not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete 'reviewers/ratings/:id').not_to be_routable
    end

    it 'routes to #create' do
      expect(post 'reviewers/ratings').to route_to 'reviewers/ratings#create'
    end

    it 'routes to #update' do
      expect(put 'reviewers/ratings/:id').to route_to 'reviewers/ratings#update', id: ':id'
    end
  end
end
