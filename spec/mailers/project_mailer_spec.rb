require 'spec_helper'

RSpec.describe ProjectMailer do

  describe '#proposal' do
    let(:project) { build_stubbed :project }

    subject { described_class.proposal(project) }

    it 'sends a mail with link to orga/projects/:id' do
      expected_url = orga_project_url(project, protocol: 'https')
      expect(subject.body.to_s).to include expected_url
    end

    context 'with recipients' do
      it 'sends mail to every organiser' do
        expect(subject.to).to match_array %w[summer-of-code@railsgirls.com]
      end
    end
  end
end
