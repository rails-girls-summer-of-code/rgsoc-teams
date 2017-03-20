require 'spec_helper'

RSpec.describe ProjectMailer do
  let(:project) { build :project }

  describe '#proposal' do
    subject { described_class.proposal(project) }

    it 'sends a mail with link to orga/projects/:id' do
      expected_url = project_url(project, protocol: 'https')
      expected_url = orga_projects_url(protocol: 'https')
      expect(subject.body.to_s).to include expected_url
    end

    context 'with recipients' do
      it 'sends mail to every organiser' do
        expect(subject.to).to match_array %w[contact@rgsoc.org]
      end
    end
  end

  describe '#comment' do
    let!(:comment) { create :comment, commentable: project }
    let(:commenter) { comment.user }

    subject { described_class.comment(project, comment) }

    it 'sends to every subscriber but the new commenter' do
      expected_recipients = project.subscribers - [comment.user]
      expect(subject.to).to match_array expected_recipients.map(&:email)
    end
  end
end
