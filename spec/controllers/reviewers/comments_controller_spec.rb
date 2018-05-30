require 'rails_helper'

RSpec.describe Reviewers::CommentsController, type: :controller do
  render_views

  let(:valid_attributes) { { text: FFaker::CheesyLingo.sentence } }
  let(:user) { create(:user) }

  before do
    user.roles.create(name: 'reviewer')
    sign_in user
  end

  describe 'application comment' do
    let(:application) { create(:application) }
    let(:params) { { commentable_id: application.id, commentable_type: 'Application' } }

    context 'with valid params' do
      it 'creates a new Comment' do
        expect {
          post :create, params: { comment: params.merge(valid_attributes) }
        }.to change(Comment, :count).by(1)
      end

      it 'redirects to comment on application page' do
        post :create, params: { comment: params.merge(valid_attributes) }
        id = Comment.last.id
        expect(response).to redirect_to([:reviewers, application, anchor: "comment_#{id}"])
      end
    end
    context 'with invalid params (no text)' do
      it 'does not create new Comment' do
        expect {
          post :create, params: { comment: params }
        }.not_to change(Comment, :count)
      end

      it 'redirects to the application page with flash' do
        post :create, params: { comment: params }
        expect(flash[:alert]).to be_present
        expect(response).to redirect_to([:reviewers, application])
      end
    end
  end
end
