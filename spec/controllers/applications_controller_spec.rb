require 'spec_helper'

describe ApplicationsController do
  render_views

  before do
    Timecop.travel(Time.utc(2013, 5, 2))
  end

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
        expect(response).to render_template 'new'
        assigns(:application_form).errors.full_messages.each do |error_msg|
          expect(response.body).to match CGI.escapeHTML(error_msg)
        end
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


    describe 'application period' do
      context 'period is over' do
        before do
          Timecop.travel(Time.utc(2014, 5, 2, 23, 59))
        end

        it 'new renders applications_end template when over' do
          get :new
          expect(response).to render_template 'ended'
        end

        it 'create renders applications_end template when over' do
          post :create
          expect(response).to render_template 'ended'
        end

        after do
          Timecop.return
        end
      end
    end
  end

end
