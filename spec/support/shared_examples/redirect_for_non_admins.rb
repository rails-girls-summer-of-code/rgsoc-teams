RSpec.shared_examples 'redirects for non-admins' do |method: 'get', action: 'index', **args|
  describe "#{method.to_s.upcase} #{action}" do
    shared_examples_for 'redirects to root path' do
      it 'redirects to root path' do
        send(method, action, *args)
        expect(response).to redirect_to root_path
        expect(flash[:alert]).to be_present
      end
    end

    context 'not logged in' do
      it_behaves_like 'redirects to root path'
    end

    context 'logged in as non-admin' do
      before do
        user = mock_model('User', admin?: false)
        allow(controller).to receive(:current_user).and_return(user)
      end

      it_behaves_like 'redirects to root path'
    end

    context 'logged in as admin' do
      include_context 'with admin logged in'

      it 'allows the controller action' do
        send(method, action, *args)
        expect(response).to have_http_status(:success)
      end
    end
  end
end
