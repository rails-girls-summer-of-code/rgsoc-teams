require 'spec_helper'

describe 'teams/index' do
  let(:teams)   { [FactoryGirl.build(:team), FactoryGirl.build(:team)] }
  let(:can_add) { false }

  before :each do
    assign :teams, teams
    view.stub(:can?).and_return(true)
    view.stub(:can?).with(:create, an_instance_of(Team)).and_return(can_add)
    render
  end

  it 'renders a list of teams' do
    assert_select 'tr>td', text: "Team #{teams.first.name} (#{teams.first.projects})", count: 1
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
