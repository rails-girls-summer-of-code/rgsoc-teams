require 'spec_helper'

describe Rating::StudentsController, type: :controller do
  render_views

  describe 'GET show' do
    let(:student) { create :student }

    it 'requires login' do
      get :show, id: student.id
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    it 'requires reviewer role' do
      sign_in create(:organizer)
      get :show, id: student.id
      expect(response).to redirect_to root_path
      expect(flash[:alert]).to be_present
    end

    context 'when reviewer' do
      let(:user) { create :reviewer }

      before { sign_in user }

      context 'when student not rated by user yet' do
        before { get :show, id: student }

        it 'assigns @student' do
          expect(assigns :student).to eq student
        end

        it 'assigns @applications' do
          expect(assigns :applications).to be
        end

        it 'assigns new @rating from user' do
          expect(assigns :rating).to be_a_new Rating
          expect(assigns :rating).to have_attributes(user: user, rateable: student)
        end

        it 'assigns @data (rating data)' do
          expect(assigns :data).to be_a RatingData
        end

        it 'renders rating/students/show' do
          expect(response).to render_template 'rating/students/show'
        end
      end
      context 'when student already rated by user' do
        let!(:rating) { create :rating, :for_student, user: user, rateable: student }

        it 'assigns existing @rating' do
          get :show, id: student
          expect(assigns :rating).to eq rating
        end
      end
    end
  end
end
