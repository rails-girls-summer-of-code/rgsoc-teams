require 'spec_helper'

describe JobOffersController do
  render_views

  let(:job_offer) { FactoryGirl.create(:job_offer) }

  describe 'GET index' do
    context 'as an anonymous user' do
      it 'denies access' do
        pending
      end
    end

    context 'as a registered user' do
      it 'denies access' do
        pending
      end
    end

    context 'as a student' do
      before { job_offer }

      it 'renders the index template' do
        get :index
        expect(response).to render_template 'index'
      end
    end
  end

end
