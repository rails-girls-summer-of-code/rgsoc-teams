require 'spec_helper'

describe ApplicationsController do
  describe 'routing' do
    it 'routes to #new' do
      expect(get('/application_forms')).to route_to('applications#new')
      expect(get('/application')).to route_to('applications#new')
    end

    it 'routes to #create' do
      expect(post('/application_forms')).to route_to('applications#create')
    end
  end
end
