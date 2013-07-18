require 'spec_helper'

describe 'teams/show' do
  let(:team)     { stub_model(Team, name: 'Name', description: 'Description') }
  let(:can_edit) { false }

  before(:each) do
    assign(:team, team)
    view.stub(:can?).with(:crud, :comments).and_return(false)
    view.stub(:can?).with(:join, team).and_return(false)
    view.stub(:can?).with(:edit, team).and_return(can_edit)
    render
  end

  it 'renders attributes in <p>' do
    rendered.should match(/Name/)
  end

  describe 'can edit teams' do
    let(:can_edit) { true }

    it 'renders an manage team links' do
      assert_select "a[href='#{edit_team_path(team)}']", count: 1
    end
  end

  describe 'can not edit team' do
    it 'does not render manage team links' do
      assert_select "a[href='#{edit_team_path(team)}']", count: 0
    end
  end
end
