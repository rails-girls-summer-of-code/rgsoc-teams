require 'spec_helper'

describe Supervisor::CommentsController do
  render_views
  let(:valid_attributes) { { "text" => FFaker::Lorem.paragraph } }
  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }

  describe 'POST create' do
    describe 'with valid params' do

      before do
        user.roles.create(name: 'supervisor', team: team)
        sign_in user
      end

      context 'team comment' do
        it 'creates a new Comment' do
          expect {
            post :create, {:comment => valid_attributes.merge(team_id: team.id)}, valid_session
          }.to change(Comment, :count).by(1)
        end

        it 'redirects to the dashboard page' do
          post :create, {:comment => valid_attributes.merge(team_id: team.id)}, valid_session
          expect(response).to redirect_to supervisor_path
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
               { comment: valid_attributes.merge(team_id: team.id) },
               valid_session
        end

        before do
          subject
        end

        it 'creates a new Comment and redirects to team page' do
          expect(comment.persisted?).to eq(true)
          expect(response).to redirect_to supervisor_path
        end

        it 'enqueues a CommentMailer' do
          expect(mailer_jobs.size).to eq(1)
        end
      end
    end

    describe "with another team's supervisor" do
      let(:anotherteam) { FactoryGirl.create(:team) }
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