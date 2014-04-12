require 'spec_helper'

describe 'companies/edit' do
  let(:user) { FactoryGirl.create(:user)  }

  before(:each) do
    @company = assign(:user, Company.new)
    controller.stub(:current_user).and_return(user)
  end

  it 'renders the edit user form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', companies_path(@company), 'post' do
      assert_select 'input#company_name[name=?]', 'company[name]'
      assert_select 'input#company_website[name=?]', 'company[website]'
      assert_select 'input#company_student_slots[name=?]', 'company[student_slots]'
      assert_select 'input#company_coaches_number[name=?]', 'company[coaches_number]'
    end
  end
end
