require 'rails_helper'

RSpec.describe Supervisors::CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post('supervisors/comments')).to route_to('supervisors/comments#create')
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
