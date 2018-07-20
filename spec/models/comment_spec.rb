require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:commentable) }
  end

  describe 'scopes' do
    describe '.ordered' do
      subject(:ordered) { described_class.ordered.to_a }

      let!(:comment1) { create(:comment, :for_team) }
      let!(:comment2) { create(:comment, :for_application) }
      let!(:comment3) { create(:comment, :for_team) }

      it 'returns comments ordered by their created_at timestamp' do
        expect(ordered).to eq [comment3, comment2, comment1]
      end

      it 'returns the most recently created comment first' do
        comment3.update(created_at: 2.days.ago)
        expect(ordered).to eq [comment2, comment1, comment3]
      end
    end
  end

  describe 'callbacks' do
    describe 'before_save' do
      let(:comment) { build(:comment, commentable: team, user: user) }
      let(:user)    { create(:user) }
      let(:team)    { create(:team, checked: nil) }

      it 'checks the team with the author of the comment' do
        expect { comment.save }.to change(team, :checked).from(nil).to(user)
      end

      context 'when the comment is for an application' do
        let(:comment)     { build(:comment, commentable: application) }
        let(:application) { create(:application, team: team) }

        it 'does not change the team' do
          expect { comment.save }.not_to change(team, :checked)
        end
      end
    end

    describe 'after_commit' do
      subject(:run_callbacks) { comment.run_callbacks(:commit) }

      context 'when the commentable is a project' do
        let(:comment)     { create(:comment, commentable: project) }
        let(:project)     { create(:project) }
        let(:mail_double) { instance_double(ActionMailer::MessageDelivery) }

        it 'sends an email to orga' do
          expect(ProjectMailer).to receive(:comment).with(project, comment).and_return(mail_double)
          expect(mail_double).to receive(:deliver_later)
          run_callbacks
        end
      end

      context 'when the commentable is an application' do
        let(:comment) { create(:comment, :for_application) }

        it 'does not send any mails' do
          expect(ProjectMailer).not_to receive(:comment)
          run_callbacks
        end
      end
    end
  end

  describe '#for_application?' do
    subject { comment }

    context 'when comment on an application' do
      let(:comment) { create(:comment, :for_application) }

      it { is_expected.to be_for_application }
    end

    context 'when comment on a team' do
      let(:comment) { create(:comment, :for_team) }

      it { is_expected.not_to be_for_application }
    end
  end
end
