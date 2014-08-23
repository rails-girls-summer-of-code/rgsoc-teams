require 'spec_helper'

describe CalendarController do
  describe 'routing' do
    it 'routes to #index' do
      expect(get('/calendar/index')).to route_to('calendar#index')
    end

    it 'routes to #events' do
      expect(get('/calendar/events')).to route_to('calendar#events')
    end
  end
end
