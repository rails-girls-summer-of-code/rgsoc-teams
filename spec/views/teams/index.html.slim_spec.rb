require 'spec_helper'

describe 'teams/index' do
  before(:each) do
    assign(:teams, [
      stub_model(Team,
        name: 'Name',
        description: 'Description',
      ),
      stub_model(Team,
        name: 'Name',
        description: 'Description',
      )
    ])
  end

  it 'renders a list of teams' do
    render
    assert_select 'tr>td', text: 'Name', count: 2
  end
end
