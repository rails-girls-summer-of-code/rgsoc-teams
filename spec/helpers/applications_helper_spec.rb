require 'spec_helper'

xdescribe ApplicationsHelper do
  describe '.rating_classes_for' do
    let(:user) { mock_model(User) }
    let(:rating) { mock_model(Rating) }

    before(:each) do
      allow(rating).to receive(:pick?).and_return(false)
      allow(rating).to receive(:user).and_return(nil)
    end

    it 'returns an empty string' do
      expect(rating_classes_for(rating, user)).to eq('')
    end

    it 'returns "pick" when pick is true' do
      allow(rating).to receive(:pick?).and_return(true)
      expect(rating_classes_for(rating, user)).to eq('pick')
    end

    it 'returns "own_rating" when rating user and user match' do
      allow(rating).to receive(:user).and_return(user)
      expect(rating_classes_for(rating, user)).to eq('own_rating')
    end
  end
  describe '.application_classes_for' do
    let(:application) { mock_model(Application) }

    before do
      allow(application).to receive(:selected?).and_return(false)
      allow(application).to receive(:volunteering_team?).and_return(false)
    end

    it 'cycles through even and odd' do
      expect(application_classes_for(application)).to eq('even')
      expect(application_classes_for(application)).to eq('odd')
    end

    it 'returns "selected" when selected? is true' do
      allow(application).to receive(:selected?).and_return(true)
      expect(application_classes_for(application)).to match('selected')
    end

    it 'returns "volunteering_team" when volunteering_team? is true' do
      allow(application).to receive(:volunteering_team?).and_return(true)
      expect(application_classes_for(application)).to match('volunteering_team')
    end
  end
  describe '.link_to_application_project' do
    let(:application) { mock_model Application }

    subject(:project_link) { link_to_application_project application }

    it 'returns nil when project not set' do
      allow(application).to receive(:project)
      expect(project_link).to eq nil
    end

    context 'when project set' do
      let(:project) { build :project }
      before { allow(application).to receive(:project){project} }

      it 'returns link to project' do
        expect(project_link).to eq link_to(project.name, project)
      end
    end
  end
  describe '.format_application_projects' do
    let(:application) { build :application }
    let!(:project) { create :project }

    subject(:project_links) { format_application_projects application }

    context 'when project not set' do
      context 'when application_data contains no project ids' do
        it 'returns empty string' do
          expect(project_links).to eq ''
        end
      end
      context 'when application_data contains one project id' do
        let(:application_data) {{ 'project1_id' => project.id.to_s }}
        before { allow(application).to receive(:application_data){application_data} }

        it 'returns link to project' do
          link_to_project = link_to(project.name, project)
          expect(project_links).to eq link_to_project
        end
      end
      context 'when application_data contains two project ids' do
        let!(:project_1) { create :project }
        let!(:project_2) { create :project }
        let(:application_data) {{ 'project1_id' => project_1.id.to_s, 'project2_id' => project_2.id.to_s }}
        before { application.application_data = application_data }

        it 'returns links to both projects' do
          link_to_project_1 = link_to(project_1.name, project_1)
          link_to_project_2 = link_to(project_2.name, project_2)
          expect(project_links).to include(link_to_project_1, link_to_project_2)
        end
      end
    end
    context 'when project set' do
      before { application.project = project }

      context 'when application_data contains no project ids' do
        it 'returns link to project' do
          link_to_project = link_to(project.name, project)
          expect(project_links).to eq link_to_project
        end
      end
      context 'when application_data contains project ids' do
        let!(:other_project) { create :project }
        let(:application_data) {{ 'project1_id' => other_project.id.to_s }}
        before { application.application_data = application_data }

        it 'returns link to set project' do
          link_to_project = link_to(project.name, project)
          expect(project_links).to eq link_to_project
        end
      end
    end
  end
  describe '.format_application_money' do
    let(:application) { build :application, application_data: application_data }

    subject(:application_money) { format_application_money application }

    context 'when not student_application_money data' do
      let(:application_data) {{}}

      it 'returns empty string' do
        expect(application_money).to eq ""
      end
    end
    context 'when student_application_money for first student' do
      let(:application_data) {{ 'student0_application_money' => '1100' }}

      it 'returns amount in $ without ct' do
        expect(application_money).to eq "$1,100"
      end
    end
    context 'when student_application_money for both students' do
      let(:application_data) {{ 'student0_application_money' => '1100',
                                'student1_application_money' => '2300' }}

      it 'returns both amounts in $ without ct' do
        expect(application_money).to eq "$1,100\n$2,300"
      end
    end
  end
end
