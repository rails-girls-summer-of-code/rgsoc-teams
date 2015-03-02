require 'spec_helper'

describe 'root routing' do

  before do
    expect(Season).to receive(:current).and_return(season)
    Rails.application.reload_routes!
  end

  context 'before season started' do
    let(:season) { double(:started? => false) }

    it 'routes to users#index' do
      expect(get('/')).to route_to('users#index')
    end
  end

  context 'after season started' do
    let(:season) { double(:started? => true) }

    it 'routes to users#index' do
      expect(get('/')).to route_to('activities#index')
    end
  end
end
