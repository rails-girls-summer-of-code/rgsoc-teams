require 'spec_helper'

describe ApplicationsController do
  render_views

  before do
    Timecop.travel(Time.utc(2013, 3, 15))
  end

  let(:team) { create :team }

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
      allow(controller).to receive_messages(authenticate_user!: true)
      allow(controller).to receive_messages(signed_in?: true)
      allow(controller).to receive_messages(current_user: user)
    end

    describe 'GET new' do
      it 'fails if part of two student teams' do
        skip "See https://github.com/rails-girls-summer-of-code/rgsoc-teams/issues/138"
      end

      it 'redirects to application_drafts#new' do
        get :new
        expect(response).to redirect_to apply_path
      end
    end

    describe 'POST create' do
      before { user.save}

      it 'fails to create invalid record' do
        pending 'This is not how we do applications anymore'

        expect do
          post :create, application: { student_name: nil }
        end.not_to change { user.applications.count }
        expect(response).to render_template 'new'
        assigns(:application_form).errors.full_messages.each do |error_msg|
          expect(response.body).to match CGI.escapeHTML(error_msg)
        end
      end

      it 'creates a new application' do
        pending 'This is not how we do applications anymore'

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
          create(:season, applications_close_at: 2.weeks.ago)
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
