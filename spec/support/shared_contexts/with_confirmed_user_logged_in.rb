RSpec.shared_context 'with confirmed user logged in' do
  let(:current_user) { create(:user) }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
    allow(current_user).to receive(:confirmed?).and_return(true)
  end
end
