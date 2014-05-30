require 'spec_helper'

describe ConferencesController do
  render_views

  describe 'GET index' do
    before { get :index }

    specify do
      expect(response.response_code).to eq 200
      expect(response).to render_template('conferences/index')
    end
  end
end
