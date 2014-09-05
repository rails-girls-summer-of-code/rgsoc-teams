require 'spec_helper'

describe 'teams/new' do
  before(:each) do
    assign(:team, stub_model(Team, name: 'Team A+', description: 'The best',).as_new_record)
    view.stub(:can?).and_return(true)
  end

  it 'renders new team form' do
    view.stub(:accessible_roles).and_return(Role::TEAM_ROLES) # what.
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form[action=?][method=?]', teams_path, 'post' do
      assert_select 'input#team_name[name=?]', 'team[name]'
      #assert_select 'textarea#team_description[name=?]', 'team[description]'   #the new view to form a team does not have this
    end
  end
end
