require 'spec_helper'

describe 'teams/edit' do
  before(:each) do
    @team = assign(:team, stub_model(Team, name: 'Team A+', description: 'The best'))
    view.stub(:can?).and_return(true)
  end

  it 'renders the edit team form' do
    view.stub(:accessible_roles).and_return(Role::TEAM_ROLES) # what.
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
      assert_select 'form[action=?][method=?]', team_path(@team), 'post' do
      assert_select 'input#team_name[name=?]', 'team[name]'
      end
  end

end