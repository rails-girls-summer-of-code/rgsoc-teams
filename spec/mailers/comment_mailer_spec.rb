require 'spec_helper'

RSpec.describe CommentMailer do
  let(:team)    { build_stubbed :team }
  let(:comment) { build_stubbed :comment, commentable: team }

  describe 'email' do
    subject { described_class.email comment }

    it 'sends to the main summer of code email address' do
      expect(subject.to).to match_array %w[ mail@rgsoc.org ]
    end
  end
end
