require 'rails_helper'

RSpec.describe StatusUpdatesController, type: :controller do
  render_views

  let(:status_update) { create :status_update, :published }

  describe "GET show" do
    it "returns http success" do
      get :show, params: { id: status_update.to_param }
      expect(assigns(:status_update)).to eql status_update
      expect(response).to have_http_status(:success)
    end
  end
end
