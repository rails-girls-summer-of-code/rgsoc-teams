require 'rails_helper'

RSpec.describe Organizers::UsersInfoController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/organizers/users/info')).to route_to('organizers/users_info#index')
    end
  end
end
