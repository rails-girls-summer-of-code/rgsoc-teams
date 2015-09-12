require 'spec_helper'

describe Supervisor::DashboardController do
  render_views
  describe 'routes for dashboard', type: :routing do
    it 'routes /dashboard to the dashboard controller' do
      expect(get('/supervisor/dashboard')).to route_to('supervisor/dashboard#index')
    end
    it 'routes /supervisor to the dashboard controller' do
      expect(get('/supervisor')).to route_to('supervisor/dashboard#index')
    end
  end
end
#
#
#
#
#     context "with non-supervisor logged in"
#       it "should redirect non-supervisors"
#       it "should redirect supervisors on a different team"
#       it "should redirect supervisors on past season's teams"
# end
#
  # describe 'access for supervisors only', type: :controller do
  #   context 'with supervisor logged in' do
  #     let(:current_user) { build_stubbed(:user) }
  #
  #     before do
  #       allow(current_user).to receive(:supervisor?).and_return(true)
  #       allow(controller).to receive(:current_user).and_return(current_user)
  #     end
  #     it 'renders the dashboard (index template)' do
  #       get :index
  #       expect(response).to be_success
  #       expect(response).to render_template :index
  #     end
  #   end
  # end
#end


#   describe 'access for supervisors only' do
#     context 'with supervisor logged in' do
#       let(:current_user) { build_stubbed(:user) }
#
#       before do
#         allow(current_user).to receive(:supervisor?).and_return(true)
#         allow(controller).to receive(:current_user).and_return(current_user)
#       end
#
#       it 'renders the dashboard (index template)' do
#         #get '/supervisor/dashboard#index'
#         #expect(response).to be_success
#         #expect(response).to render_template 'index'
#       end
#     end
#   end
# end
