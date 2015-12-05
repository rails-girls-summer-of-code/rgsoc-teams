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
      let!(:organizers) { create_list(:organizer_role, 2).map(&:user) }
      let!(:others) { create_list :supervisor_role, 1 }

      it 'sends mail to every organiser' do
        expect(subject.to).to match_array organizers.map(&:email)
      end
    end
  end
end
