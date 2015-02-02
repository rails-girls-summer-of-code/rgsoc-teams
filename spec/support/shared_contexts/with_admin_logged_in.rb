RSpec.shared_context 'with admin logged in' do
  let(:current_user) { mock_model('User', :admin? => true) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end
end
