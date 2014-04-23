require 'spec_helper'

describe MailingsController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/mailings')).to route_to('mailings#index')
    end

    it 'routes to #show' do
      expect(get('/mailings/1')).to route_to('mailings#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get('/mailings/1/edit')).to route_to('mailings#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post('/mailings')).to route_to('mailings#create')
    end

    it 'routes to #update' do
      expect(put('/mailings/1')).to route_to('mailings#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete('/mailings/1')).to route_to('mailings#destroy', id: '1')
    end
  end
end
