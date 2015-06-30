require 'spec_helper'

RSpec.describe CommentMailer do
  let(:team)    { build_stubbed :team }
  let(:comment) { build_stubbed :comment, team: team }

  describe 'email' do
    let!(:organizer)   { create :organizer }
    let!(:supervisors) { create_list :supervisor, 2 }

    before do
      # To test uniqueness of email:
      supervisors.last.roles.create name: 'organizer'
    end

    subject { described_class.email comment }

    it 'sends to all organizers and supervisors' do
      emails = (supervisors.map(&:email) + [organizer.email])
      expect(subject.to).to match_array emails
    end
  end
end
