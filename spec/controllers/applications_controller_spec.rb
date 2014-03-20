require 'spec_helper'

describe ApplicationsController do
  render_views

  context 'as an anonymous user' do
    describe 'GET new' do
      it 'renders the "sign_in" template' do
        get :new
        expect(response).to render_template 'sign_in'
      end
    end
  end

  context 'as an authenticated user' do
    let(:user) { FactoryGirl.build(:user) }

    before do
      controller.stub(authenticate_user!: true)
      controller.stub(signed_in?: true)
      controller.stub(current_user: user)
    end

    describe 'GET new' do
      it 'renders the "new" template' do
        get :new
        expect(response).to render_template 'new'
        expect(assigns(:application_form).student_name).to eq user.name
        expect(assigns(:application_form).student_email).to eq user.email
      end
    end

    describe 'POST create' do
      before { user.save}

      it 'fails to create invalid record' do
        expect do
          post :create, application: { student_name: nil }
        end.not_to change { user.applications.count }
        expect(flash.now[:alert]).to be_present
        expect(response).to render_template 'new'
      end

      it 'creates a new application' do
        allow_any_instance_of(ApplicationForm).
          to receive(:valid?).and_return(true)
        valid_attributes = FactoryGirl.attributes_for(:application).merge(
          student_name: user.name,
          student_email: user.email
        )
        expect do
          post :create, application: valid_attributes
          puts assigns(:application_form).errors.full_messages
        end.to change { user.applications.count }.by(1)
        expect(response).to render_template 'create'
      end
    end
  end

end
