require 'rails_helper'

RSpec.describe ProjectMaintenance, type: :model do
  describe 'its associations' do
    it { is_expected.to belong_to :project }
    it { is_expected.to belong_to :user }

    it_behaves_like 'HasSeason'
  end

  describe 'its validations' do
    it { is_expected.to validate_presence_of :project }
    it { is_expected.to validate_presence_of :user }

    it { is_expected.to validate_uniqueness_of(:project_id).scoped_to(:season_id, :user_id) }
  end

  describe 'its callbacks' do
    describe 'before_create' do
      describe 'auto-assigning the position' do
        subject(:position) { create(:project_maintenance, **scoping).position }

        context 'when no record for its uniqueness scope exists' do
          let(:scoping) { {} }

          it { is_expected.to eql 0 }
        end

        context 'when a record for its uniqueness scope already exists' do
          let!(:existing) { create :project_maintenance }
          let(:scoping) { { project: existing.project, season: existing.season } }

          it { is_expected.to eql 1 }
        end
      end
    end
  end
end
