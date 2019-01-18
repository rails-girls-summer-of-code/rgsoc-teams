require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  render_views
  let(:valid_attributes) { { "text" => FFaker::CheesyLingo.sentence } }
  let(:user) { create(:user) }

  before do
    user.roles.create(name: 'reviewer')
    sign_in user
  end

  describe 'POST create' do
    describe 'project comment' do
      let(:project) { create :project }
      let(:params) { { commentable_id: project.id, commentable_type: 'Project' } }
      let(:comment) { Comment.last }
      let(:anchor) { "comment_#{comment.id}" }

      context 'with valid params' do
        it 'creates a new Comment' do
          expect {
            post :create, params: { comment: params.merge(valid_attributes) }
          }.to change(Comment, :count).by 1
        end

        it 'redirects to comment on project page' do
          post :create, params: { comment: params.merge(valid_attributes) }
          expect(response).to redirect_to [project, anchor: anchor]
        end
      end

      context 'with invalid params (no text)' do
        it 'does not create new Comment' do
          expect {
            post :create, params: { comment: params }
          }.not_to change(Comment, :count)
        end

        it 'redirects to project page' do
          post :create, params: { comment: params }
          expect(flash[:alert]).to be_present
          expect(response).to redirect_to project
        end
      end
    end
  end
end
