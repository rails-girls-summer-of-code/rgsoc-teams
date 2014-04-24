require 'spec_helper'

describe CalendarController do
  describe 'GET index' do
    before { get :index }

    specify do
      expect(response.response_code).to eq 200
      expect(response).to render_template('calendar/index')
    end
  end

  describe 'GET events' do
    before { get :events, format: :json }

    specify do
      expect(response.response_code).to eq 200
    end
  end
end
