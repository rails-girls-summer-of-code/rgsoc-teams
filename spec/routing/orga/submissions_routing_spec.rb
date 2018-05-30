require 'rails_helper'

RSpec.describe Organizers::SubmissionsController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/organizers/mailings/1/submissions')).to route_to('organizers/submissions#index', mailing_id: '1')
    end

    it 'routes to #new' do
      expect(get('organizers/mailings/1/submissions/new')).to route_to('organizers/submissions#new', mailing_id: '1')
    end

    it 'routes to #show' do
      expect(get('organizers/mailings/1/submissions/1')).to route_to('organizers/submissions#show', id: '1', mailing_id: '1')
    end

    it 'routes to #edit' do
      expect(get('organizers/mailings/1/submissions/1/edit')).to route_to('organizers/submissions#edit', id: '1', mailing_id: '1')
    end

    it 'routes to #create' do
      expect(post('organizers/mailings/1/submissions')).to route_to('organizers/submissions#create', mailing_id: '1')
    end

    it 'routes to #update' do
      expect(put('organizers/mailings/1/submissions/1')).to route_to('organizers/submissions#update', id: '1', mailing_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('organizers/mailings/1/submissions/1')).to route_to('organizers/submissions#destroy', id: '1', mailing_id: '1')
    end
  end
end
