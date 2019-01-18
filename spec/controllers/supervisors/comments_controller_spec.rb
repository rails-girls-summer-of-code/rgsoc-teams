require 'rails_helper'

RSpec.describe Supervisors::CommentsController, type: :controller do
  render_views
  let(:valid_attributes) { { "text" => FFaker::Lorem.paragraph } }
  let(:user) { create(:user) }
  let(:team) { create(:team) }

  describe 'POST create' do
    describe 'with valid params' do
      before do
        user.roles.create(name: 'supervisor', team: team)
        sign_in user
      end

      context 'team comment' do
        it 'creates a new Comment' do
          expect {
            post :create, params: { comment: valid_attributes.merge(commentable_id: team.id, commentable_type: 'Team') }
          }.to change(Comment, :count).by(1)
        end

        it 'redirects to the dashboard page' do
          post :create, params: { comment: valid_attributes.merge(commentable_id: team.id, commentable_type: 'Team') }
          expect(response).to redirect_to supervisors_dashboard_path
        end

        after do
          clear_enqueued_jobs
        end

        let(:comment) { team.comments.last }
        let(:mailer_jobs) do
          enqueued_jobs.select do |job|
            job[:job] == ActionMailer::DeliveryJob &&
                job[:args][0] == 'CommentMailer' &&
                job[:args][1] == 'email'
          end
        end

        subject do
          post :create,
               params: { comment: valid_attributes.merge(commentable_id: team.id, commentable_type: 'Team') }
        end

        before do
          subject
        end

        it 'creates a new Comment and redirects to team page' do
          expect(comment.persisted?).to eq(true)
          expect(response).to redirect_to supervisors_dashboard_path
        end

        it 'enqueues a CommentMailer' do
          expect(mailer_jobs.size).to eq(1)
        end
      end
    end

    describe "with another team's supervisor" do
      let(:anotherteam) { create(:team) }
      let(:comment) { anotherteam.comments.last }

      before do
        user.roles.create(name: 'supervisor', team: anotherteam)
        sign_in user
      end

      it 'will not save a comment on a non-supervised team' do
        expect(comment).not_to be_a_new(Comment)
      end
    end
  end
end
