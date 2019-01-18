require 'rails_helper'

RSpec.describe ApplicationsHelper, type: :helper do
  describe '.link_to_application_project' do
    let(:application) { mock_model Application }

    subject(:project_link) { link_to_application_project application }

    it 'returns nil when project not set' do
      allow(application).to receive(:project)
      expect(project_link).to eq nil
    end

    context 'when project set' do
      let(:project) { build :project }
      before { allow(application).to receive(:project) { project } }

      it 'returns link to project' do
        expect(project_link).to eq link_to(project.name, project)
      end
    end
  end
end
