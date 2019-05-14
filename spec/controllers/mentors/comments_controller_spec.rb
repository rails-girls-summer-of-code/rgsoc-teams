require 'rails_helper'

RSpec.describe Mentors::CommentsController, type: :controller do
  render_views

  let(:user) { create(:user) }

  describe 'POST create' do
    context 'as an unauthenticated user' do
      it 'redirects to the landing page' do
        post :create
        expect(response).to redirect_to root_path
      end
    end

    context 'as an unauthorized user' do
      it 'redirects to the landing page' do
        sign_in user
        post :create
        expect(response).to redirect_to root_path
      end
    end

    context 'as a project_maintainer' do
      let!(:project) { create(:project, :in_current_season, :accepted, submitter: user) }
      let(:params)   { { mentor_comment: { commentable_id: 1, text: 'something' } } }
      let(:comment)  { proc { Mentor::Comment.last } }

      before { sign_in user }

      subject { post :create, params: params }

      it 'creates a new Mentor::Comment for the user' do
        expect { subject }.to change { Mentor::Comment.count }.by(1)
      end

      it 'sets the user and commentable_type' do
        subject
        expect(comment.call).to have_attributes(
          user:              user,
          text:              'something',
          commentable_id:    1,
          commentable_type: 'Mentor::Application')
      end

      it 'redirect_to the mentor application show view' do
        subject
        anchor = "mentor_comment_#{comment.call.id}"
        expect(response).to redirect_to mentors_application_path(id: 1, anchor: anchor)
      end
    end
  end

  describe 'PUT update' do
    context 'as an unauthenticated user' do
      it 'redirects to the landing page' do
        put :update, params: { id: 1 }
        expect(response).to redirect_to root_path
      end
    end

    context 'as an unauthorized user' do
      before { sign_in user }

      it 'redirects to the landing page' do
        put :update, params: { id: 1 }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a project_maintainer' do
      let!(:project) { create(:project, :in_current_season, :accepted, submitter: user) }

      subject(:request) { put :update, params: params }

      before { sign_in user }

      context 'when comment exists' do
        let!(:comment) { Mentor::Comment.create(user: user, commentable_id: 1, text: 'something') }
        let(:params)   { { id: comment.id, mentor_comment: { text: 'something else' } } }
        let(:anchor)   { "mentor_comment_#{comment.id}" }

        it 'updates the comment and redirects to the mentor application show view' do
          expect { request }.to change { comment.reload.text }.from('something').to('something else')
          expect(response).to redirect_to mentors_application_path(id: 1, anchor: anchor)
        end
      end

      context 'when comment does not exist' do
        let(:params) { { id: -1, mentor_comment: { text: 'something else' } } }

        it 'returns a 404' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when comment does not belong to user' do
        let(:comment) { Mentor::Comment.create(user: build(:user), commentable_id: 1, text: 'something') }
        let(:params)  { { id: comment.id, mentor_comment: { text: 'something else' } } }

        it 'returns a 404' do
          expect { request }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
