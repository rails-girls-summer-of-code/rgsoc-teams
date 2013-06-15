require 'spec_helper'

describe 'users/new' do
  before(:each) do
    assign(:user, stub_model(User,
      name: 'MyString',
      email: 'MyString',
      location: 'MyString',
      bio: 'MyString',
      homepage: 'MyString',
      role: 'coach'
    ).as_new_record)
  end

  it 'renders new user form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', users_path, 'post' do
      assert_select 'input#user_name[name=?]', 'user[name]'
      assert_select 'input#user_email[name=?]', 'user[email]'
      assert_select 'input#user_location[name=?]', 'user[location]'
      assert_select 'input#user_bio[name=?]', 'user[bio]'
      assert_select 'input#user_homepage[name=?]', 'user[homepage]'
    end
  end
end
