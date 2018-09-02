require 'rails_helper'

RSpec.describe Mentor::Application, type: :model do
  describe 'attributes' do
    subject { described_class.new }

    it { is_expected.to respond_to :id                   }
    it { is_expected.to respond_to :team_name            }
    it { is_expected.to respond_to :project_name         }
    it { is_expected.to respond_to :project_id           }
    it { is_expected.to respond_to :project_plan         }
    it { is_expected.to respond_to :why_selected_project }
    it { is_expected.to respond_to :choice               }
    it { is_expected.to respond_to :signed_off_by        }
    it { is_expected.to respond_to :signed_off_at        }
    it { is_expected.to respond_to :mentor_fav           }
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

      context 'when passing multiple projects' do
        let(:projects) { Project.where(id: [project1.id, project2.id]) }

        it 'returns applications of the season which chose one of the projects as first choice' do
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
          last_season = Season.create name: Date.today.year - 1
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

  describe '.find(id:, projects:, season: Season.current)' do
    let!(:project1)      { create(:project, :in_current_season) }
    let!(:project2)      { create(:project, :in_current_season) }
    let!(:other_project) { create(:project) }
    let(:projects)       { Project.where(id: [project1.id, project2.id]) }

    shared_examples :found_an_application do |choice|
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
          project_plan:         application.data.send("plan_project#{choice}"),
          why_selected_project: application.data.send("why_selected_project#{choice}"),
          choice:               choice
        )
      end

      it 'contains all relevant data for student0' do
        expect(subject.student0).to have_attributes(
          coding_level:     application.data.student0_application_coding_level.to_i,
          code_samples:     application.data.student0_application_code_samples,
          name:             application.data.student0_application_name,
          learning_history: application.data.student0_application_learning_history,
          language_learning_period: application.data.student0_application_language_learning_period,
          skills:           application.data.student0_application_skills
        )
      end

      it 'contains all relevant data for student1' do
        expect(subject.student1).to have_attributes(
          coding_level:     application.data.student1_application_coding_level.to_i,
          code_samples:     application.data.student1_application_code_samples,
          name:             application.data.student1_application_name,
          learning_history: application.data.student1_application_learning_history,
          language_learning_period: application.data.student1_application_language_learning_period,
          skills:           application.data.student1_application_skills
        )
      end
    end

    subject { described_class.find(id: application.id, projects: projects) }

    context 'when application exists as first choice' do
      let!(:application) { create(:application, :in_current_season, :for_project, project1: project1) }

      it_behaves_like :found_an_application, 1
    end

    context 'when application exists as second choice' do
      let!(:application) do
        create(:application, :in_current_season, :for_project, project1: other_project, project2: project1)
      end

      it_behaves_like :found_an_application, 2
    end

    context 'when wrong project' do
      let(:projects)      { Project.where(id: other_project.id) }
      let!(:application)  { create(:application, :in_current_season, :for_project, project1: project1) }

      it 'raises a NotFound error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end

    context 'when application does not exist' do
      let(:application) { double(id: 1) }

      it 'raises a NotFound error' do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe '#find_or_initialize_comment_by(mentor)' do
    let!(:application)       { create(:application) }
    let(:mentor_application) { described_class.new(id: application.id) }
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

  describe '#mentor_fav!' do
    let(:application) { create(:application) }

    subject { m_application.mentor_fav! }

    shared_examples :a_mentor_fav do |choice|
      let(:other) { (choice % 2) + 1 }

      it 'adds a fav for the chosen project to the persisted application record' do
        expect { subject }
          .to change { application.reload.data.send("mentor_fav_project#{choice}") }
          .from(nil).to('true')
      end

      it 'does not change the mentor_fav for the other project' do
        expect { subject }
          .not_to change { application.reload.data.send("mentor_fav_project#{other}") }
      end
    end

    context 'when project 1st choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 1) }
      include_examples :a_mentor_fav, 1
    end

    context 'when project 2nd choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 2) }
      include_examples :a_mentor_fav, 2
    end
  end

  describe '#revoke_mentor_fav!' do
    let(:application) do
      create(:application,
        application_data: {
          'mentor_fav_project1': 'true',
          'mentor_fav_project2': 'true'
        }
      )
    end

    subject { m_application.revoke_mentor_fav! }

    shared_examples :a_mentor_fav do |choice|
      let(:other) { (choice % 2) + 1 }

      it 'removes the fav for the chosen project' do
        expect { subject }
          .to change { application.reload.application_data["mentor_fav_project#{choice}"] }
          .from('true').to(nil)
      end

      it 'does not change the mentor_fav for the other project' do
        expect { subject }
          .not_to change { application.reload.data.send("mentor_fav_project#{other}") }
      end
    end

    context 'when project 1st choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 1) }
      include_examples :a_mentor_fav, 1
    end

    context 'when project 2nd choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 2) }
      include_examples :a_mentor_fav, 2
    end
  end

  describe '#sign_off!' do
    let(:application) { create(:application) }
    let(:mentor)      { create(:mentor)      }

    def keys_for(choice)
      ["signed_off_at_project#{choice}", "signed_off_by_project#{choice}"]
    end

    subject { m_application.sign_off!(as: mentor) }

    shared_examples :a_mentor_sign_off do |choice|
      let(:other) { (choice % 2) + 1 }
      let(:now)   { Time.now.utc.to_s }

      before { Timecop.freeze(now) }
      after { Timecop.return       }

      it 'adds the signoff time and user id to the application' do
        expect { subject }
          .to change { application.reload.application_data.values_at(*keys_for(choice)) }
          .from([nil, nil])
          .to contain_exactly(now, mentor.id.to_s)
      end

      it 'does not change the signoff for the other project' do
        expect { subject }
          .not_to change { application.reload.application_data.values_at(*keys_for(other)) }
      end
    end

    context 'when project 1st choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 1) }
      include_examples :a_mentor_sign_off, 1
    end

    context 'when project 2nd choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 2) }
      include_examples :a_mentor_sign_off, 2
    end
  end

  describe '#revoke_sign_off!' do
    let(:application) { create(:application, application_data: data) }
    let(:mentor)      { create(:mentor)      }
    let(:data) do
      {
        signed_off_at_project1: Time.now.utc.to_s,
        signed_off_by_project1: mentor.id.to_s,
        signed_off_at_project2: Time.now.utc.to_s,
        signed_off_by_project2: '99'
      }
    end

    def keys_for(choice)
      ["signed_off_at_project#{choice}", "signed_off_by_project#{choice}"]
    end

    subject { m_application.revoke_sign_off! }

    shared_examples :a_mentor_sign_off do |choice|
      let(:other) { (choice % 2) + 1 }

      it 'sets the signoff time and user id to nil' do
        expect { subject }
          .to change { application.reload.application_data.values_at(*keys_for(choice)) }
          .to([nil, nil])
      end

      it 'does not change the signoff for the other project' do
        expect { subject }
          .not_to change { application.reload.application_data.values_at(*keys_for(other)) }
      end
    end

    context 'when project 1st choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 1) }
      include_examples :a_mentor_sign_off, 1
    end

    context 'when project 2nd choice' do
      let(:m_application) { described_class.new(id: application.id, choice: 2) }
      include_examples :a_mentor_sign_off, 2
    end
  end

  describe '#signed_off?' do
    it 'returns true if signed_off_at was set' do
      application = described_class.new(signed_off_at: Time.now.utc.to_s)
      expect(application).to be_signed_off
    end

    it 'returns false if signed_off_at was not set' do
      application = described_class.new
      expect(subject).not_to be_signed_off
    end
  end

  describe '#mentor_fav?' do
    it 'returns true if mentor_fav was set' do
      application = described_class.new(mentor_fav: 'true')
      expect(application).to be_mentor_fav
    end

    it 'returns false if mentor_fav was not set' do
      application = described_class.new
      expect(subject).not_to be_mentor_fav
    end
  end

  describe '#to_param' do
    it 'returns the underlying active record id' do
      subject.id = 4711
      expect(subject.to_param).to eql '4711'
    end
  end
end
