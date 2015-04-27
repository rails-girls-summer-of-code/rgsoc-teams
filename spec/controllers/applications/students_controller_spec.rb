require 'spec_helper'

describe Applications::StudentsController, type: :controller do
  render_views

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
    end

    context "when a rating doesn't exist" do
      before do
        subject
      end

      it "assigns @student to the User" do
        expect(assigns(:student)).to eq(user)
      end

      it "assigns @applications to user.applications" do
        expect(assigns(:applications)).to match_array(applications)
      end

      it "assigns @rating to a new rating" do
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating).persisted?).to eq(false)
      end
    end

    context "when a rating exists" do
      let!(:rating) do
        FactoryGirl.create(:rating, user: current_user, rateable: user)
      end

      before do
        subject
      end

      it "assigns @rating to existing rating" do
        expect(assigns(:rating)).to be_a(Rating)
        expect(assigns(:rating).persisted?).to eq(true)
      end
    end

  end
end
