require 'spec_helper'

describe UsersInfoController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/users/info')).to route_to('users_info#index')
    end
  end
end
