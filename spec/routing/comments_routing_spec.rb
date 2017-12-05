require 'spec_helper'

RSpec.describe Supervisor::CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post('supervisor/comments')).to route_to('supervisor/comments#create')
    end
  end
end

RSpec.describe CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post('/comments')).to route_to('comments#create')
    end
  end
end
