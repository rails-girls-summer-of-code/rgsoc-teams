require 'spec_helper'

describe CalendarController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/calendar/index')).to route_to('calendar#index')
    end
  end
end
