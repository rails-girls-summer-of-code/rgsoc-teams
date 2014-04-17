require 'spec_helper'

describe 'users/index' do
  before(:each) do
    assign(:filters, { all: 'All', foo: 'Bar' })
    assign(:users, [
      stub_model(User, name: 'Name', email: 'Email', location: 'Location', bio: 'Bio', homepage: 'Homepage', role: 'coach'),
      stub_model(User, name: 'Name', email: 'Email', location: 'Location', bio: 'Bio', homepage: 'Homepage', role: 'coach')
    ])
    controller.stub(:current_user).as_null_object
  end

  it 'renders a list of users' do
    render
    assert_select 'tr>td', text: 'Name', count: 2
  end
end
