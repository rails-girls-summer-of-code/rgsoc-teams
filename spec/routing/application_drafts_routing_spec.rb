require 'rails_helper'

RSpec.describe ApplicationDraftsController, type: :routing do
  describe 'routing' do
    it 'does not route to #show' do
      expect(get 'application_drafts/:id').not_to be_routable
    end

    it 'does not route to #destroy' do
      expect(delete 'application_drafts/:id').not_to be_routable
    end

    it 'routes to #index' do
      expect(get 'application_drafts').to route_to 'application_drafts#index'
    end

    it 'routes to #new' do
      expect(get 'application_drafts/new').to route_to 'application_drafts#new'
    end

    it 'routes /apply to #new' do
      expect(get 'apply').to route_to 'application_drafts#new'
    end

    it 'routes to #edit' do
      expect(get 'application_drafts/:id/edit').to route_to 'application_drafts#edit', id: ':id'
    end

    it 'routes to #update' do
      expect(put 'application_drafts/:id').to route_to 'application_drafts#update', id: ':id'
    end

    it 'routes to #apply' do
      expect(put 'application_drafts/:id/apply').to route_to 'application_drafts#apply', id: ':id'
    end

    it 'routes to #check' do
      expect(get 'application_drafts/:id/check').to route_to 'application_drafts#check', id: ':id'
    end
  end
  describe 'routing helpers' do
    it 'routes application_drafts_path to #index' do
      expect(get application_drafts_path).to route_to 'application_drafts#index'
    end

    it 'routes new_application_draft_path to #new' do
      expect(get new_application_draft_path).to route_to 'application_drafts#new'
    end

    it 'routes apply_path to #new' do
      expect(get apply_path).to route_to 'application_drafts#new'
    end

    it 'routes edit_application_draft_path to #edit' do
      expect(get edit_application_draft_path(':id')).to route_to 'application_drafts#edit', id: ':id'
    end

    it 'routes application_draft_path to #update' do
      expect(put application_draft_path(':id')).to route_to 'application_drafts#update', id: ':id'
    end

    it 'routes apply_application_draft_path to #apply' do
      expect(put apply_application_draft_path(':id')).to route_to 'application_drafts#apply', id: ':id'
    end

    it 'routes check_application_draft_path to #check' do
      expect(get check_application_draft_path(':id')).to route_to 'application_drafts#check', id: ':id'
    end
  end
end
