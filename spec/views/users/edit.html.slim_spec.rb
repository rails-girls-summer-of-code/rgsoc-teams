require 'spec_helper'

describe 'users/edit' do
  before(:each) do
    @user = assign(:user, stub_model(User,
      name: 'MyString',
      email: 'MyString',
      location: 'MyString',
      bio: 'MyString',
      homepage: 'MyString',
      role: 'coach'
    ))
  end

  it 'renders the edit user form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', user_path(@user), 'post' do
      assert_select 'input#user_name[name=?]', 'user[name]'
      assert_select 'input#user_email[name=?]', 'user[email]'
      assert_select 'input#user_location[name=?]', 'user[location]'
      assert_select 'input#user_bio[name=?]', 'user[bio]'
      assert_select 'input#user_homepage[name=?]', 'user[homepage]'
    end
  end
end
