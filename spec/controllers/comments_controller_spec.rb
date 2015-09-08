require 'spec_helper'

describe CommentsController do
  render_views
  let(:valid_attributes) { { "text" => FFaker::Lorem.paragraph } }
  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }
  let(:application) { FactoryGirl.create(:application) }

  before do
    user.roles.create(name: 'organizer')
    sign_in user
  end

  describe 'POST create' do
    describe 'with valid params' do
      context 'applications comment' do
        it 'creates a new Comment' do
          expect {
            post :create, {:comment => valid_attributes.merge(application_id: application.id)}, valid_session
          }.to change(Comment, :count).by(1)
        end

        it 'redirects to the team page' do
          post :create, {:comment => valid_attributes.merge(application_id: application.id)}, valid_session
          expect(response).to redirect_to(application)
        end
      end
    end
  end
end


