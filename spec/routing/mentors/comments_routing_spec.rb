require 'rails_helper'

RSpec.describe Mentors::CommentsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post '/mentors/comments').to route_to 'mentors/comments#create'
    end

    it 'routes to #update' do
      expect(put '/mentors/comments/id').to route_to('mentors/comments#update', id: 'id')
    end
  end

  describe 'routing helpers' do
    it 'routes post mentor_comments_path to #index' do
      expect(post mentors_comments_path).to route_to 'mentors/comments#create'
    end

    it 'routes put mentor_comment_path to #show' do
      expect(put mentors_comment_path(id: 'id')).to route_to('mentors/comments#update', id: 'id')
    end
  end
end
