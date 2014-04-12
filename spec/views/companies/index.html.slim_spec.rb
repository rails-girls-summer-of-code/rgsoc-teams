require 'spec_helper'

describe 'companies/index' do
  before(:each) do
    assign(:companies, [
      stub_model(Company, name: 'Stuff GmbH', owner: FactoryGirl.create(:user)),
      stub_model(Company, name: 'Dinge Sàrl', owner: FactoryGirl.create(:user))
    ])
    controller.stub(:current_user).as_null_object
  end

  it 'renders a list of users' do
    render
    assert_select 'tr>td', text: 'Stuff GmbH', count: 1
  end
end

