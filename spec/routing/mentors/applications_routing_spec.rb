require 'rails_helper'

RSpec.describe Mentors::ApplicationsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get '/mentors/applications').to route_to 'mentors/applications#index'
    end

    it 'routes to #show' do
      expect(get '/mentors/applications/id').to route_to('mentors/applications#show', id: 'id')
    end
  end

  describe 'routing helpers' do
    it 'routes get mentors_applications_path to #index' do
      expect(get mentors_applications_path).to route_to 'mentors/applications#index'
    end

    it 'routes get mentors_application_path to #show' do
      expect(get mentors_application_path(id: 'id')).
        to route_to('mentors/applications#show', id: 'id')
    end
  end
end
