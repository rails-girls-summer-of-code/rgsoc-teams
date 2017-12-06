require 'spec_helper'

RSpec.describe Rating::TodosController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get 'rating/todos').to route_to 'rating/todos#index'
    end
  end
  describe 'routing helpers' do
    it 'routes rating_todos_path to #show' do
      expect(get rating_todos_path).to route_to 'rating/todos#index'
    end
  end
end
