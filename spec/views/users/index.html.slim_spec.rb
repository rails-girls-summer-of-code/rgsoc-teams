require 'spec_helper'

describe 'users/index' do
  before(:each) do
    assign(:users, [
      stub_model(User,
        name: 'Name',
        email: 'Email',
        location: 'Location',
        bio: 'Bio',
        homepage: 'Homepage',
        role: 'coach'
      ),
      stub_model(User,
        name: 'Name',
        email: 'Email',
        location: 'Location',
        bio: 'Bio',
        homepage: 'Homepage',
        role: 'coach'
      )
    ])
  end

  it 'renders a list of users' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'tr>td', text: 'Name', count: 2
    assert_select 'tr>td', text: 'Email', count: 2
    assert_select 'tr>td', text: 'Location', count: 2
    assert_select 'tr>td', text: 'Bio', count: 2
    assert_select 'tr>td', text: 'Homepage', count: 2
  end
end
