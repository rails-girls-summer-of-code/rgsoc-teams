require 'rails_helper'

RSpec.describe ContributorsController, type: :controller do
  render_views

  describe 'GET index' do
    let!(:user)      { create(:user) }
    let!(:coach)     { create(:coach) }
    let!(:organizer) { create(:organizer) }

    it 'returns json representation of user with relevant roles' do
      get :index, format: :json
      expect(assigns(:contributors).sort).to eq [coach, organizer].sort
    end

    it 'includes teamless organizers' do
      organizer.roles.each { |r| r.update! team: nil }
      get :index, format: :json
      expect(assigns(:contributors).sort).to eq [coach, organizer].sort
    end
  end
end
