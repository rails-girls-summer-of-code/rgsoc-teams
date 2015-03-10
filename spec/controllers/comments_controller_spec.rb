require 'spec_helper'

describe CommentsController do
  render_views

  let(:valid_attributes) { { "text" => Faker::Lorem.paragraph } }
  let(:valid_session) { {} }
  let(:user) { FactoryGirl.create(:user) }
  let(:team) { FactoryGirl.create(:team) }
  let(:application) { FactoryGirl.create(:application) }

  before do
    user.roles.create(name: 'organizer')
    sign_in user
  end

  describe "POST create" do
    describe "with valid params" do
      context 'team comment' do
        it "creates a new Comment" do
          expect {
            post :create, {:comment => valid_attributes.merge(team_id: team.id)}, valid_session
          }.to change(Comment, :count).by(1)
        end

        it "redirects to the team page" do
          post :create, {:comment => valid_attributes.merge(team_id: team.id)}, valid_session
          expect(response).to redirect_to(team)
        end
      end

      context 'applications comment' do
        it "creates a new Comment" do
          expect {
            post :create, {:comment => valid_attributes.merge(application_id: application.id)}, valid_session
          }.to change(Comment, :count).by(1)
        end

        it "redirects to the team page" do
          post :create, {:comment => valid_attributes.merge(application_id: application.id)}, valid_session
          expect(response).to redirect_to(application)
        end
      end

      context 'team comment' do
        after do
          clear_enqueued_jobs
        end

        let(:comment) { team.comments.last }
        let(:mailer_jobs) do
          enqueued_jobs.select do |job|
            job[:job] == ActionMailer::DeliveryJob &&
            job[:args][0] == 'CommentMailer' &&
            job[:args][1] == 'email' &&
            job[:args][3] == comment
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
          expect(comment.present?).to eq(true)
          expect(response).to redirect_to team
        end

        it 'enqueues a CommentMailer' do
          expect(mailer_jobs.size).to eq(1)
        end
      end
    end
  end
end
