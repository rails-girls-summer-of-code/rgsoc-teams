require 'spec_helper'

describe FormApplicationsController do

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
      allow(controller).to receive_messages(authenticate_user!: true)
      allow(controller).to receive_messages(signed_in?: true)
      allow(controller).to receive_messages(current_user: user)
    end

    describe 'POST submit' do
      it 'creates a new application' do
        allow_any_instance_of(FormApplication).
          to receive(:valid?).and_return(true)
        valid_attributes = FactoryGirl.attributes_for(:form_application).merge(
          name: user.name,
          email: user.email
        )
        expect do
          post :create, application: valid_attributes
          puts assigns(:form_application).errors.full_messages
        end
      end
    end
  end
end
