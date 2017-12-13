require 'spec_helper'

RSpec.describe Rating::ApplicationsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get '/rating/applications/:id').to route_to 'rating/applications#show', id: ':id'
    end

    it 'routes to #edit' do
      expect(get '/rating/applications/:id/edit').to route_to 'rating/applications#edit', id: ':id'
    end

    it 'routes to #update' do
      expect(put '/rating/applications/:id').to route_to 'rating/applications#update', id: ':id'
    end

    it 'routes to #index' do
      expect(get '/rating/applications').to route_to 'rating/applications#index'
    end
  end
  describe 'routing helpers' do
    it 'routes get rating_application_path to #show' do
      expect(get rating_application_path(':id')).to route_to 'rating/applications#show', id: ':id'
    end

    it 'routes get edit_rating_application_path to #show' do
      expect(get edit_rating_application_path(':id')).to route_to 'rating/applications#edit', id: ':id'
    end

    it 'routes put rating_application_path to #update' do
      expect(put rating_application_path(':id')).to route_to 'rating/applications#update', id: ':id'
    end

    it 'routes rating_applications_path to #index' do
      expect(get rating_applications_path).to route_to 'rating/applications#index'
    end
  end
end
