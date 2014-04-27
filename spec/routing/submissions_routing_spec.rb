require 'spec_helper'

describe SubmissionsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/mailings/1/submissions')).to route_to('submissions#index', mailing_id: '1')
    end

    it 'routes to #new' do
      expect(get('/mailings/1/submissions/new')).to route_to('submissions#new', mailing_id: '1')
    end

    it 'routes to #show' do
      expect(get('/mailings/1/submissions/1')).to route_to('submissions#show', id: '1', mailing_id: '1')
    end

    it 'routes to #edit' do
      expect(get('/mailings/1/submissions/1/edit')).to route_to('submissions#edit', id: '1', mailing_id: '1')
    end

    it 'routes to #create' do
      expect(post('/mailings/1/submissions')).to route_to('submissions#create', mailing_id: '1')
    end

    it 'routes to #update' do
      expect(put('/mailings/1/submissions/1')).to route_to('submissions#update', id: '1', mailing_id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/mailings/1/submissions/1')).to route_to('submissions#destroy', id: '1', mailing_id: '1')
    end
  end
end
