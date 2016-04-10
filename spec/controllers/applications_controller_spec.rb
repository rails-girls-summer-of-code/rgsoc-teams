require 'spec_helper'

describe ApplicationsController do
  render_views

  before do
    Timecop.travel(Time.utc(2013, 3, 15))
  end

  describe 'GET index' do
    context 'as an authenticated user' do
      let(:user) { create :user }
      before { sign_in user }

      context 'as a non-reviewer' do
        it 'disallows access to the list of applications' do
          get :index
          expect(response).to redirect_to root_path
        end
      end
      context 'as a reviewer' do
        let(:user) { create(:reviewer_role).user }
        let(:application_draft) { create :application_draft, :appliable }
        let!(:application) do
          CreatesApplicationFromDraft.new(application_draft).tap { |c| c.save }.application
        end

        it 'lists all available applications' do
          get :index
          expect(response).to be_success
        end
      end
    end
  end
end
