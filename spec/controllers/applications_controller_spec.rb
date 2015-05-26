require 'spec_helper'

describe ApplicationsController do
  render_views

  before do
    Timecop.travel(Time.utc(2013, 3, 15))
  end

  let(:team) { create :team }

  context 'as an authenticated user' do
    let(:user) { FactoryGirl.build(:user) }

    before do
      allow(controller).to receive_messages(authenticate_user!: true)
      allow(controller).to receive_messages(signed_in?: true)
      allow(controller).to receive_messages(current_user: user)
    end

    describe 'GET index' do
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
