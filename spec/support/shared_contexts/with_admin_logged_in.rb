RSpec.shared_context 'with admin logged in' do
  let(:current_user) { build_stubbed(:user) }

  before do
    allow(current_user).to receive(:admin?).and_return(true)
    allow(controller).to receive(:current_user).and_return(current_user)
  end
end
