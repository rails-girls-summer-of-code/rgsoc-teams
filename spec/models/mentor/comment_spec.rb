require 'rails_helper'

RSpec.describe Mentor::Comment, type: :model do
  describe 'database' do
    it 'uses the Comment table under the hood' do
      comment         = described_class.create
      comment_from_db = Comment.find_by(id: comment.id, commentable_type: 'Mentor::Application')
      mentor_comment  = Mentor::Comment.find comment.id

      expect(comment).to be_a described_class
      expect(comment).to eq mentor_comment
      expect(comment).to have_attributes(
        id: comment_from_db.id,
        text:             comment_from_db.text,
        commentable_id:   comment_from_db.commentable_id,
        commentable_type: comment_from_db.commentable_type)
    end

    it 'has a default scope to include only comments on Mentor::Applications' do
      create(:comment)
      create(:comment, :for_team)
      create(:comment, :for_application)
      comment = described_class.create

      expect(described_class.all).to contain_exactly comment
    end
  end

  describe 'callbacks' do
    it 'removes empty comments on update' do
      comment = described_class.create(text: 'something')
      expect { described_class.update(comment.id, text: '') }.
        to change { described_class.count }.by(-1)
    end
  end

  describe 'associations' do
    it { is_expected.to belong_to(:user).optional }
    it { is_expected.not_to belong_to(:commentable).optional }
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
