require 'spec_helper'

describe Mentor::CommentsController do
  describe 'routing' do
    it 'routes to #create' do
      expect(post '/mentor/comments').to route_to 'mentor/comments#create'
    end

    it 'routes to #update' do
      expect(put '/mentor/comments/id').to route_to('mentor/comments#update', id: 'id')
    end
  end

  describe 'routing helpers' do
    it 'routes post mentor_comments_path to #index' do
      expect(post mentor_comments_path).to route_to 'mentor/comments#create'
    end

    it 'routes put mentor_comment_path to #show' do
      expect(put mentor_comment_path(id: 'id')).to route_to('mentor/comments#update', id: 'id')
    end
  end
end
