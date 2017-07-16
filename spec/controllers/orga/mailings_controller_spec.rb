require 'spec_helper'

describe Orga::MailingsController do
  render_views

  it_behaves_like 'redirects for non-admins'

  let(:mailing)        { FactoryGirl.create(:mailing) }

  context 'with admin logged in' do
    include_context 'with admin logged in'

    describe 'GET index' do
      it 'renders the index template' do
        get :index
        expect(response).to be_success
        expect(response).to render_template 'index'
      end
    end

    describe 'GET show' do
      it 'shows a mailing' do
        get :show, params: { id: mailing.to_param }
        expect(response).to be_success
        expect(response).to render_template 'show'
      end
    end
  end





    # shared_examples_for 'Denies Access to Mailing' do
    #   it 'denies access' do
    #     get :show, params: { id: mailing.to_param }
    #     expect(response).to redirect_to root_path
    #     expect(flash[:alert]).to match 'not authorized'
    #   end
    # end

    # context 'with user logged in' do
    #   let(:user) { FactoryGirl.create(:student) }
    #
    #   include_context 'User logged in'
    #
    #   # it_behaves_like 'Denies Access to Mailing'
    #
    #   it 'renders the show template for user in recipients list' do
    #     mailing.update(to: %w(students))
    #     get :show, params: { id: mailing.to_param }
    #     expect(response).to render_template 'show'
    #   end
    #
    # end

    # context 'as guest user' do
    #   it_behaves_like 'Denies Access to Mailing'
    # end
  # end

end
