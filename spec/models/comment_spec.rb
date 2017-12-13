require 'spec_helper'

RSpec.describe Comment, type: :model do
  it { is_expected.to belong_to(:user) }
  it { is_expected.to belong_to(:commentable) }

  before do
    @first_comment = create(:team_comment)
    @second_comment = create(:application_comment)
  end

  describe '.ordered' do
    it 'returns comments orderd DESC by created_at' do
      @first_comment.update_attribute(:created_at, Time.now - 2.days)
      expect(Comment.ordered.count).to eq(2)
      expect(Comment.ordered.first).to eq(@second_comment)
    end
  end

  describe '.for_application?' do
    it 'returns true when application is assigned' do
      expect(@second_comment.for_application?).to eq(true)
    end
  end

  it 'sets a checked on the team' do
    @first_comment.commentable.checked = nil

    expect do
      @first_comment.save!
    end.to change(@first_comment.commentable, :checked)
  end
end
