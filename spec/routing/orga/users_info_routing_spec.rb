require 'spec_helper'

RSpec.describe Orga::UsersInfoController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/orga/users/info')).to route_to('orga/users_info#index')
    end
  end
end
