require 'rails_helper'

RSpec.describe Reviewers::TodosController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get 'reviewers/todos').to route_to 'reviewers/todos#index'
    end
  end
  describe 'routing helpers' do
    it 'routes reviwers_todos_path to #show' do
      expect(get reviewers_todos_path).to route_to 'reviewers/todos#index'
    end
  end
end
