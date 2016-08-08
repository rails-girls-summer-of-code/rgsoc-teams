RSpec.shared_examples 'redirects for non-users' do
  # OPTIMIZE test actions other than 'index'

  let(:accepted_team) { create :team, :in_current_season, kind: 'sponsored' }

  shared_examples_for 'disallows access to students namespace' do
    before do
      allow(controller).to receive(:current_user).and_return(user)
    end

    it 'redirects to root path with an error message' do
      get :index
      expect(flash[:alert]).to be_present
      expect(response).to redirect_to root_path
    end
  end

  context 'as an admin' do
    let(:user) { create :organizer }
    it_behaves_like 'disallows access to students namespace'
  end

  context 'as a guest' do
    let(:user) { nil }
    it_behaves_like 'disallows access to students namespace'
  end

  context 'as a coach' do
    let(:user) { create(:coach_role, team: accepted_team).user }
    it_behaves_like 'disallows access to students namespace'
  end

  context 'as a mentor' do
    let(:user) { create(:mentor_role, team: accepted_team).user }
    it_behaves_like 'disallows access to students namespace'
  end

  context 'as a student' do
    context 'who is not part of an accepted team' do
      let(:unaccepted_team) { create :team, :in_current_season, kind: nil }
      let(:user) { create(:student_role, team: unaccepted_team).user }
      it_behaves_like 'disallows access to students namespace'
    end

    context 'who is part of an accepted team from last season' do
      let(:last_season)   { Season.create name: Date.today.year-1 }
      let(:accepted_team) { create :team, season: last_season, kind: 'sponsored' }
      let(:user)          { create(:student_role, team: accepted_team).user }
      it_behaves_like 'disallows access to students namespace'
    end

    context 'who is part of an accepted team for this season' do
      let(:user) { create(:student_role, team: accepted_team).user }
      before { allow(controller).to receive(:current_user).and_return(user) }

      it 'allows access' do
        get :index
        expect(response).to be_success
      end
    end
  end

end
