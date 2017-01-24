require 'spec_helper'

describe Mentor::ApplicationsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get '/mentor/applications').to route_to 'mentor/applications#index'
    end

    it 'routes to #show' do
      expect(get '/mentor/applications/id').to route_to('mentor/applications#show', id: 'id')
    end
  end

  describe 'routing helpers' do
    it 'routes get mentor_applications_path to #index' do
      expect(get mentor_applications_path).to route_to 'mentor/applications#index'
    end

    it 'routes get mentor_application_path to #show' do
      expect(get mentor_application_path(id: 'id')).
        to route_to('mentor/applications#show', id: 'id')
    end
  end
end
