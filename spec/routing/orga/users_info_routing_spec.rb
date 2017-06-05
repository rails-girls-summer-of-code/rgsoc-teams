require 'spec_helper'

describe Orga::UsersInfoController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/orga/users/info')).to route_to('orga/users_info#index')
    end
  end
end
