require 'spec_helper'

describe 'teams/index' do
  before(:each) do
    assign(:teams, [
      stub_model(Team, number: 1, name: 'Name', description: 'Description'),
      stub_model(Team, number: 1, name: 'Name', description: 'Description')
    ])
  end

  it 'renders a list of teams' do
    render
    assert_select 'tr>td', text: 'Team #1 Name', count: 2
  end
end
