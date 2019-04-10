require 'rails_helper'

RSpec.describe 'Browsing the front page', type: :request do
  describe 'GET /' do
    let!(:status_update) { create :status_update, :published }

    it 'renders the activity log' do
      get '/'
      expect(response).to have_http_status(:success)
    end

    context 'as a user with a funny timezone' do
      let(:user) { create :user, timezone: 'Atlantic/Atlantis' }

      before { sign_in user }

      it 'will not fail on timezone settings' do
        get '/'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
