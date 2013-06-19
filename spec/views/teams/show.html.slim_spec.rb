require 'spec_helper'

describe 'teams/show' do
  let(:team)       { stub_model(Team, name: 'Name', description: 'Description') }
  let(:can_manage) { false }

  before(:each) do
    assign(:team, team)
    view.should_receive(:can?).with(:manage, team).and_return(can_manage)
    render
  end

  it 'renders attributes in <p>' do
    rendered.should match(/Name/)
  end

  describe 'can manage teams' do
    let(:can_manage) { true }

    it 'renders an manage team links' do
      assert_select "a[href='#{edit_team_path(team)}']", count: 1
    end
  end

  describe 'can not manage team' do
    it 'does not render manage team links' do
      assert_select "a[href='#{edit_team_path(team)}']", count: 0
    end
  end
end
