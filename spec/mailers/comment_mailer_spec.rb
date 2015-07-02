require 'spec_helper'

RSpec.describe CommentMailer do
  let(:team)    { build_stubbed :team }
  let(:comment) { build_stubbed :comment, team: team }

  describe 'email' do
    subject { described_class.email comment }

    it 'sends to all organizers and supervisors' do
      expect(subject.to).to match_array %w[ summer-of-code@railsgirls.com ]
    end
  end
end
