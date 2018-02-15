RSpec.shared_context 'with student logged in' do
  let(:team) { create :team, kind: 'full_time' }
  let(:current_user) { create(:student_role, team: team).user }

  before do
    allow(controller).to receive(:current_user).and_return(current_user)
  end
end
