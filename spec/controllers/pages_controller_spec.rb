require 'spec_helper'

RSpec.describe PagesController do
  render_views

  describe 'GET show' do
    it 'renders the show template' do
      get :show
      expect(response).to render_template 'show'
    end
  end


end
