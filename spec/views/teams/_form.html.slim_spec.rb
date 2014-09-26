require 'spec_helper'

describe 'teams/_form' do
  before :each do
    @team = Team.new
    @ability = Object.new
    @ability.extend(CanCan::Ability)
  end

  describe 'admin must be able to select team'
  before :each do
    @ability.stub(:can?).with(:select, @team).and_return(true)
  end
  it 'should show the required field' do
    render
    expect(rendered).to match /Selected Team?/
  end
end
