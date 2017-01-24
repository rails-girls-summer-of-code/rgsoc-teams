require 'spec_helper'

describe Mentor::CommentsController do
  render_views

  describe 'POST create' do
    context 'as an unauthenticated user' do
      it 'redirects to the landing page' do
        post :create
        expect(response).to redirect_to root_path
      end
    end

    context 'as an unauthorized user' do
      it 'redirects to the landing page' do
        sign_in create(:developer)
        post :create
        expect(response).to redirect_to root_path
      end
    end

    context 'as a mentor' do
      let(:mentor) { create(:mentor) }
      let(:params) {{ mentor_comment: { commentable_id: 1, text: 'something' } }}

      before { sign_in mentor }

      subject { post :create, params: params }

      it 'creates a new Mentor::Comment for the user' do
        expect { subject }.to change { Mentor::Comment.count }.by(1)
      end

      it 'sets the user and commentable_type' do
        subject
        expect(Mentor::Comment.last).to have_attributes(
          user:              mentor,
          text:              'something',
          commentable_id:   1,
          commentable_type: 'Mentor::Application')
      end

      it 'redirect_to the mentor application show view' do
        subject
        expect(response).to redirect_to mentor_application_path(id: 1, anchor: 'mentor_comment_1')
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
      it 'redirects to the landing page' do
        sign_in create(:developer)
        put :update, params: { id: 1 }
        expect(response).to redirect_to root_path
      end
    end

    context 'as a mentor' do
      let(:mentor) { create(:mentor) }

      before { sign_in mentor }

      context 'when comment exists' do
        let!(:comment) { Mentor::Comment.create(user: mentor, commentable_id: 1, text: 'something') }
        let(:params)   {{ id: comment.id, mentor_comment: { text: 'something else' } }}

        subject { put :update, params: params }

        it 'updates the comment' do
          expect { subject; comment.reload}.to change { comment.text }.
            from('something').to('something else')
        end

        it 'redirect_to the mentor application show view' do
          subject
          expect(response).to redirect_to mentor_application_path(id: 1, anchor: 'mentor_comment_1')
        end
      end

      context 'when comment does not exist' do
        it 'returns a 404' do
          params = { id: 1, mentor_comment: { text: 'something else' } }

          expect { put :update, params: params }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end

      context 'when comment does not belong to user' do
        it 'returns a 404' do
          comment = Mentor::Comment.create(user: build(:user), commentable_id: 1, text: 'something')
          params  = { id: comment.id, mentor_comment: { text: 'something else' } }

          expect { put :update, params: params }.to raise_error(ActiveRecord::RecordNotFound)
        end
      end
    end
  end
end
