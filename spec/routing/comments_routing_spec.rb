require 'spec_helper'

describe CommentsController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post('/comments')).to route_to('comments#create')
    end
  end
end
