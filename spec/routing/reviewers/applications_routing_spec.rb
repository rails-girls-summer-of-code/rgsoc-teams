require 'rails_helper'

RSpec.describe Reviewers::ApplicationsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get '/reviewers/applications/:id').to route_to 'reviewers/applications#show', id: ':id'
    end

    it 'routes to #edit' do
      expect(get '/reviewers/applications/:id/edit').to route_to 'reviewers/applications#edit', id: ':id'
    end

    it 'routes to #update' do
      expect(put '/reviewers/applications/:id').to route_to 'reviewers/applications#update', id: ':id'
    end

    it 'routes to #index' do
      expect(get '/reviewers/applications').to route_to 'reviewers/applications#index'
    end
  end
  describe 'routing helpers' do
    it 'routes get reviewers_application_path to #show' do
      expect(get reviewers_application_path(':id')).to route_to 'reviewers/applications#show', id: ':id'
    end

    it 'routes get edit_reviewers_application_path to #show' do
      expect(get edit_reviewers_application_path(':id')).to route_to 'reviewers/applications#edit', id: ':id'
    end

    it 'routes put reviewers_application_path to #update' do
      expect(put reviewers_application_path(':id')).to route_to 'reviewers/applications#update', id: ':id'
    end

    it 'routes reviewers_applications_path to #index' do
      expect(get reviewers_applications_path).to route_to 'reviewers/applications#index'
    end
  end
end
