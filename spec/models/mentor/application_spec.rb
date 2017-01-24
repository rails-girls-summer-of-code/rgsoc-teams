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

  describe '.find(id:, projects:, choice: 1, season: Season.current)' do
    let!(:project1)      { create(:project, :in_current_season) }
    let!(:project2)      { create(:project, :in_current_season) }
    let!(:other_project) { create(:project) }
    let(:projects)       { Project.where(id: [project1.id, project2.id]) }

    subject { described_class.find(id: application.id, projects: projects) }

    context 'when application exists' do
      let!(:application) { create(:application, :in_current_season, :for_project, project1: project1) }

      it 'returns the application mapped as Mentor::Application with Mentor::Students' do
        expect(subject).to be_a(Mentor::Application)
        expect(subject.student0).to be_a(Mentor::Student)
        expect(subject.student1).to be_a(Mentor::Student)
      end

      it 'contains all relevant attributes' do
        expect(subject).to have_attributes(
          id:                   application.id,
          project_id:           project1.id,
          team_name:            application.team.name,
          project_name:         project1.name,
          project_plan:         application.application_data["plan_project1"],
          why_selected_project: application.application_data["why_selected_project1"],
          first_choice: true
        )
      end

      it 'contains all relevant data for student0' do
        expect(subject.student0).to have_attributes(
          coding_level:     application.application_data["student0_application_coding_level"].to_i,
          code_samples:     application.application_data["student0_application_code_samples"],
          learning_history: application.application_data["student0_application_learning_history"],
          code_background:  application.application_data["student0_application_code_background"],
          skills:           application.application_data["student0_application_skills"]
        )
      end

      it 'contains all relevant data for student1' do
        expect(subject.student1).to have_attributes(
          coding_level:     application.application_data["student1_application_coding_level"].to_i,
          code_samples:     application.application_data["student1_application_code_samples"],
          learning_history: application.application_data["student1_application_learning_history"],
          code_background:  application.application_data["student1_application_code_background"],
          skills:           application.application_data["student1_application_skills"]
        )
      end
    end

    context 'when wrong project' do
      let(:projects)      { Project.where(id: other_project.id) }
      let!(:application)  { create(:application, :in_current_season, :for_project, project1: project1) }

      it 'raises a NotFound error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'application does not exist' do
      let(:application) { double(id: 1) }

      it 'raises a NotFound error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when wrong choice scope' do
      let!(:application) do
        create(:application, :in_current_season, :for_project, project1: other_project, project2: project1)
      end

      it 'raises a NotFound error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#find_or_initialize_comment_by(mentor)' do
    let(:mentor_application) { described_class.new(id: 1) }
    let(:mentor)             { create(:mentor) }

    subject { mentor_application.find_or_initialize_comment_by(mentor) }

    it 'returns the persisted comment when one exists' do
      comment = Mentor::Comment.create(commentable_id: mentor_application.id, user: mentor)
      expect(subject).to eq comment
    end

    it 'has the Mentor::Application as commentable type' do
      expect(subject).to have_attributes(
        commentable_id:   mentor_application.id,
        commentable_type: described_class.name,
        user:             mentor
      )
    end

    it 'returns a new comment if none is persisted yet' do
      expect(subject).to be_a_new(Mentor::Comment)
    end

    it 'returns a new comment if a comment for the application is persisted' do
      create(:comment, commentable_id: mentor_application.id, commentable_type: 'Application', user: mentor)
      expect(subject).to be_a_new(Mentor::Comment)
    end
  end
end
