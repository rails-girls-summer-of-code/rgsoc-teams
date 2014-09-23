require 'spec_helper'

describe 'teams/_form' do
  let(:team) { stub_model(Team, name: 'XYZ', is_selected: false ) }
  before(:each) do
    assign(:team, team)
    view.stub(:can?).with(:select, team).and_return(true)
  end
end