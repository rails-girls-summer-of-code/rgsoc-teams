require 'spec_helper'

describe Comment do
  it { should belong_to(:team) }
  it { should belong_to(:user) }
  it { should belong_to(:application) }

  before do
    @first_comment = FactoryGirl.create(:team_comment)
    @second_comment = FactoryGirl.create(:application_comment)
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
    @first_comment.team.checked = nil

    expect do
      @first_comment.save!
    end.to change(@first_comment.team, :checked)
  end
end
