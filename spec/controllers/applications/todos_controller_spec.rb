require 'spec_helper'

describe Applications::TodosController, type: :controller do
  render_views

  describe 'GET #index' do
    let(:role) { FactoryGirl.create(:reviewer_role, team: nil) }
    let(:current_user) { role.user }
    let!(:teams) { FactoryGirl.create_list(:team, 2, :applying_team, :with_applications) }
    let!(:team_rating) { teams.sample.ratings.create(user: current_user) }
    let!(:student_rating) { teams.sample.students.sample.ratings.create(user: current_user) }
    let!(:application_rating) { teams.sample.applications.sample.ratings.create(user: current_user) }

    subject { get :index }

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(current_user)
      subject
    end

    it 'assigns @teams' do
      expect(assigns(:teams)).to eq(Team.all)
    end

    it 'renders the tables' do
      teams.each do |team|
        expect(response.body).to have_tag('tr', with: { class: "team-#{team.id}"}) do
          with_tag('a', with: { href: applications_team_path(team) }, text: team.name)
          with_tag('td', text: team == team_rating.rateable ? team_rating.updated_at : 'Never')

          team.students.each do |student|
            with_tag('tr', with: { class: "student-#{student.id}"}) do
              with_tag('a', with: { href: applications_student_path(student)}, text: student.name)
              with_tag('td', text: student == student_rating.rateable ? student_rating.updated_at : 'Never')
            end
          end

          team.applications.each do |application|
            with_tag('tr', with: { class: "application-#{application.id}"}) do
              with_tag('a', with: { href: application_path(application)}, text: application.project_name)
              with_tag('td', text: application == application_rating.rateable ? application_rating.updated_at : 'Never')
            end
          end
        end
      end
    end
  end
end
