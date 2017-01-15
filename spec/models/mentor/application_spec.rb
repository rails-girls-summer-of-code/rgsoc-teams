require 'spec_helper'

describe Mentor::Application do
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

  describe '.all_for(project_is: choice:)' do
    let!(:project1)       { create(:project, :in_current_season) }
    let!(:project2)       { create(:project, :in_current_season) }
    let!(:other_project)  { create(:project, :in_current_season) }

    context 'when first choice project' do
      subject { described_class.all_for(projects: projects, choice: 1) }

      context 'when passing an empty projects collection' do
        let(:projects) { Project.where(id: -99) }

        it 'returns an empty array' do
          create(:application, :in_current_season, :for_project, project1: project1)

          expect(subject).to eq []
        end
      end

      context 'when passing only project1' do
        let(:projects) { Project.where(id: project1.id) }

        it 'returns applications of the season which chose the project as first choice' do
          first_choice  = create_list(:application, 3, :in_current_season, :for_project, project1: project1)
          second_choice = create(:application, :in_current_season, :for_project, project1: project2, project2: project1)
          other         = create(:application, :in_current_season, :for_project, project1: project2)

          ids = subject.map(&:id)
          expect(ids).to match_array first_choice.map(&:id)
          expect(ids).not_to include second_choice
          expect(ids).not_to include other
        end
      end

      context 'when passing multple projects' do
        let(:projects) { Project.where(id: [project1.id, project2.id]) }

        it 'returns applications of the season with chose one of the projects as first choice' do
          first_choice1  = create(:application, :in_current_season, :for_project, project1: project1)
          first_choice2  = create(:application, :in_current_season, :for_project, project1: project2)
          second_choice1 = create(:application, :in_current_season, :for_project, project1: build(:project), project2: project2)

          ids = subject.map(&:id)
          expect(ids).to contain_exactly(first_choice1.id, first_choice2.id)
        end
      end

      context 'when passing a project from the wrong season' do
        let(:projects) { Project.where(id: project1.id) }

        it "returns an empty array" do
          last_season = Season.create name: Date.today.year-1
          create(:application, :for_project, project1: project1, season: last_season)
          expect(subject).to eq []
        end
      end
    end

    context 'when second choice project' do
      subject { described_class.all_for(projects: projects, choice: 2) }

      context 'when passing an empty projects collection' do
        let(:projects) { Project.where(id: -99) }

        it 'returns an empty array' do
          create(:application, :in_current_season, :for_project, project1: project1)

          expect(subject).to eq []
        end
      end

      context 'when passing a single project' do
        let(:projects) { Project.where(id: project1.id) }

        it 'returns applications of the season which chose the project as first choice' do
          create(:application, :in_current_season, :for_project, project1: project1)
          second_choice = create(:application, :in_current_season, :for_project, project1: project2, project2: project1)

          expect(subject.map(&:id)).to contain_exactly second_choice.id
        end
      end
    end
  end
end
