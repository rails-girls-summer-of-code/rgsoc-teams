require 'spec_helper'

describe MailingsController do
  render_views

  describe 'GET index' do
    it 'renders the index template' do
      FactoryGirl.create(:mailing)
      get :index
      expect(response).to render_template 'index'
    end
  end
end
