require 'spec_helper'

describe Orga::SubmissionsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/orga/mailings/1/submissions')).to route_to('orga/submissions#index', mailing_id: '1')
    end

    it 'routes to #new' do
      expect(get('orga/mailings/1/submissions/new')).to route_to('orga/submissions#new', mailing_id: '1')
    end

    it 'routes to #show' do
      expect(get('orga/mailings/1/submissions/1')).to route_to('orga/submissions#show', id: '1', mailing_id: '1')
    end

    it 'routes to #edit' do
      expect(get('orga/mailings/1/submissions/1/edit')).to route_to('orga/submissions#edit', id: '1', mailing_id: '1')
    end

    it 'routes to #create' do
      expect(post('orga/mailings/1/submissions')).to route_to('orga/submissions#create', mailing_id: '1')
    end

    it 'routes to #update' do
      expect(put('orga/mailings/1/submissions/1')).to route_to('orga/submissions#update', id: '1', mailing_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('orga/mailings/1/submissions/1')).to route_to('orga/submissions#destroy', id: '1', mailing_id: '1')
    end
  end
end
