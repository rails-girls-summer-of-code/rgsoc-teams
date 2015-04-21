require 'spec_helper'

describe Applications::StudentsController, type: :controller do
  describe "GET show" do
    let(:current_user) { FactoryGirl.create(:reviewer) }
    let(:user) { FactoryGirl.create(:user) }
    let(:team) { FactoryGirl.create(:team) }
    let!(:student_role) { FactoryGirl.create(:student_role, user: user, team: team) }
    let!(:applications) { FactoryGirl.create_list(:application, 2, team: team) }

    subject do
      get :show, id: user.id
    end

    before do
      allow(controller).to receive(:authenticate_user!)
      allow(controller).to receive(:current_user).and_return(current_user)
      subject
    end

    it "assigns @student to the User" do
      expect(assigns(:student)).to eq(user)
    end

    it "assigns @applications to user.applications" do
      expect(assigns(:applications)).to match_array(applications)
    end
  end
end
