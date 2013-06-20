require 'spec_helper'

describe 'teams/index' do

  let(:teams)   { [stub_model(Team, number: 1, name: 'Name'), stub_model(Team, number: 2, name: 'Name')] }
  let(:can_add) { false }

  before :each do
    assign :teams, teams
    view.should_receive(:can?).with(:create, an_instance_of(Team)).and_return(can_add)
    render
  end

  it 'renders a list of teams' do
    assert_select 'tr>td', text: 'Team Name', count: 2
  end

  describe 'can add teams' do
    let(:can_add) { true }

    it 'renders an Add Team button' do
      assert_select "a[href='#{new_team_path}']", count: 1
    end
  end

  describe 'can not add teams' do
    it 'does not render an Add Team button' do
      assert_select "a[href='#{new_team_path}']", count: 0
    end
  end
end
