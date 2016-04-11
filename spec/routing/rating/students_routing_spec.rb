require 'spec_helper'

describe Rating::StudentsController do
  describe 'routing' do
    it 'routes to #show' do
      expect(get '/rating/students/:id').to route_to 'rating/students#show', id: ':id'
    end
  end
  describe 'routing helpers' do
    it 'routes rating_student_path to #show' do
      expect(get rating_student_path(':id')).to route_to 'rating/students#show', id: ':id'
    end
  end
end
