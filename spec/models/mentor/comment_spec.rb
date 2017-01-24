require 'spec_helper'

describe Mentor::Comment do
  describe 'database' do
    it 'uses the Comment table under the hood' do
      comment         = described_class.create
      comment_from_db = Comment.find_by(id: comment.id, commentable_type: 'Mentor::Application')
      mentor_comment  = Mentor::Comment.find comment.id

      expect(comment).to be_a described_class
      expect(comment).to eq mentor_comment
      expect(comment.attributes).to eq comment_from_db.attributes
    end

    it 'has a default scope to include only comments on Mentor::Applications' do
      create(:comment)
      create(:team_comment)
      create(:application_comment)
      comment = described_class.create

      expect(described_class.all).to contain_exactly comment
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to :user }
    it { is_expected.not_to belong_to :commentable }
  end

  describe 'attributes' do
    subject { described_class.new }

    it { is_expected.to respond_to :id               }
    it { is_expected.to respond_to :commentable_id   }
    it { is_expected.to respond_to :commentable_type }
    it { is_expected.to respond_to :text             }

    it { expect(subject.commentable_type).to eq 'Mentor::Application' }
  end
end
