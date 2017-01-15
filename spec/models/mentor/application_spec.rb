require 'spec_helper'

describe Mentor::Application, :focus do
  describe 'attributes' do
    subject { described_class.new }

    it { is_expected.to respond_to :id                   }
    it { is_expected.to respond_to :team_name            }
    it { is_expected.to respond_to :project_name         }
    it { is_expected.to respond_to :project_id           }
    it { is_expected.to respond_to :project_plan         }
    it { is_expected.to respond_to :why_selected_project }
    it { is_expected.to respond_to :first_choice         }
  end

  describe '.all_for(projects:)' do
    subject { described_class.all_for(projects: projects).map(&:id) }

    context 'when single project' do
      let!(:project)       { create(:project, :in_current_season) }
      let!(:other_project) { create(:project, :in_current_season) }
      let(:projects)       { Project.where(id: project.id) }

      let!(:first_choice)      { create_list(:application, 3, :in_current_season, :for_project,
                                 project1: project) }
      let!(:second_choice)     { create_list(:application, 2, :in_current_season, :for_project,
                                 project1: other_project, project2: project) }
      let!(:other_application) { create(:application, :in_current_season, :for_project,
                                 project1: other_project) }

      it 'includes all applications which chose the project as first choice' do
        expect(subject).to include *first_choice.map(&:id)
      end

      it 'excludes other applications' do
        expect(subject).not_to include other_application.id
      end

      it 'includes all applications which chose the project as second choice' do
        expect(subject).to include *second_choice.map(&:id)
      end
    end

    context 'when multple projects' do
      let!(:project1)      { create(:project, :in_current_season) }
      let!(:project2)      { create(:project, :in_current_season) }
      let!(:other_project) { create(:project, :in_current_season) }
      let(:projects)       { Project.where(id: [project1.id, project2.id]) }
    end
  end
end
