require 'spec_helper'

RSpec.describe Orga::CommunityController do
  render_views

  context 'with admin logged in' do
    include_context 'with admin logged in'
    describe 'PUT reset_user_availability' do

      it 'reset availability for users interested in coaching' do
        put :reset_user_availability
        expect(response).to redirect_to (orga_users_info_path)
        expect(flash[:notice]).to match(/Users were reset with success./)
      end
    end
  end
end
