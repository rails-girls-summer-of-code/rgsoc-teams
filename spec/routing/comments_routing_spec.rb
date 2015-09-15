require 'spec_helper'

describe Supervisor::CommentsController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post('supervisor/comments')).to route_to('supervisor/comments#create')
    end
  end
end

describe CommentsController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post('/comments')).to route_to('comments#create')
    end
  end
end