require 'spec_helper'

describe JobOffersController do
  render_views

  let(:user)          { create(:user) }
  let(:job_offer)     { create(:job_offer) }
  let(:valid_session) { { "warden.user.user.key" => session["warden.user.user.key"] } }

  shared_context 'Student logged in' do
    let(:student) { create(:student) }
    before { sign_in student }
  end

  shared_context 'Admin logged in' do
    let(:organizer) { create(:organizer) }
    before { sign_in organizer }
  end

  describe 'GET index' do
    context 'as an anonymous user' do
      it 'denies access' do
        get :index
        expect(response).to redirect_to root_path
      end
    end

    context 'as a registered user' do
      before { sign_in user }

      it 'denies access' do
        get :index, {}, valid_session
        expect(response).to redirect_to root_path
      end
    end

    context 'as a student' do
      include_context 'Student logged in'

      before { job_offer }

      it 'renders the index template' do
        get :index, {}, valid_session
        expect(response).to render_template 'index'
      end
    end
  end

  describe 'GET show' do
    context 'as a student' do
      include_context 'Student logged in'

      it 'renders the show template' do
        get :show, { id: job_offer.to_param }, valid_session
        expect(response).to render_template 'show'
      end
    end
  end

  describe 'GET new' do
    context 'as a student' do
      include_context 'Student logged in'

      it 'denies access' do
        get :new, {}, valid_session
        expect(response).to redirect_to root_path
      end
    end

    context 'as an admin' do
      include_context 'Admin logged in'

      it 'renders the new template' do
        get :new, {}, valid_session
        expect(response).to render_template 'new'
      end
    end
  end

  describe 'GET edit' do
    context 'as a student' do
      include_context 'Student logged in'

      it 'denies access' do
        get :edit, { id: job_offer.to_param }, valid_session
        expect(response).to redirect_to root_path
      end
    end

    context 'as an admin' do
      include_context 'Admin logged in'

      it 'renders the edit template' do
        get :edit, { id: job_offer.to_param }, valid_session
        expect(response).to render_template 'edit'
      end
    end
  end

  describe 'POST create' do
    let(:valid_attributes) { { job_offer: FactoryGirl.attributes_for(:job_offer) } }

    context 'as a student' do
      include_context 'Student logged in'

      it 'denies access' do
        expect {
          post :create, valid_attributes, valid_session
        }.not_to change { JobOffer.count }
        expect(response).to redirect_to root_path
      end
    end

    context 'as an admin' do
      include_context 'Admin logged in'

      it 'creates record and redirects' do
        expect {
          post :create, valid_attributes, valid_session
        }.to change { JobOffer.count }.by 1
        expect(response).to redirect_to assigns(:job_offer)
      end
    end

  end

  describe 'PATCH update' do
    context 'as a student' do
      include_context 'Student logged in'

      it 'denies access' do
        patch :update, { id: job_offer.to_param, job_offer: { title: 'foo' } }, valid_session
        expect(response).to redirect_to root_path
      end
    end

    context 'as an admin' do
      include_context 'Admin logged in'

      it 'updates record and redirects' do
        new_title = SecureRandom.hex(10)
        expect {
          patch :update, { id: job_offer.to_param, job_offer: { title: new_title } }, valid_session
        }.to change { job_offer.reload.title }.to new_title
        expect(response).to redirect_to job_offer
      end
    end

  end

  describe 'DELETE destroy' do
    before { job_offer }

    context 'as a student' do
      include_context 'Student logged in'

      it 'denies access' do
        expect {
          delete :destroy, { id: job_offer.to_param }, valid_session
        }.not_to change { JobOffer.count }
        expect(response).to redirect_to root_path
      end
    end

    context 'as an admin' do
      include_context 'Admin logged in'

      it 'destroys record and redirects' do
        expect {
          delete :destroy, { id: job_offer.to_param }, valid_session
        }.to change { JobOffer.count }.by(-1)
        expect(response).to redirect_to job_offers_path
      end
    end
  end

end
