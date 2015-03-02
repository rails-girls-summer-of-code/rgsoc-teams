require 'spec_helper'

RSpec.describe PagesController do
  render_views

  describe 'GET show' do
    it 'renders the help template' do
      get :show, page: 'help'
      expect(response).to render_template 'help'
    end
  end

end
