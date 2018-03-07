require 'rails_helper'

RSpec.describe ProjectMaintenance, type: :model do
  describe 'its associations' do
    it { is_expected.to belong_to :project }
    it { is_expected.to belong_to :user }
  end

  describe 'its validations' do
    it { is_expected.to validate_presence_of :project }
    it { is_expected.to validate_presence_of :user }

    it { is_expected.to validate_uniqueness_of(:project_id).scoped_to(:user_id) }
  end

  describe 'its callbacks' do
    describe 'before_create' do
      describe 'auto-assigning the position' do
        context 'for the mainainer who submitted the project' do
          subject(:position) { create(:project).project_maintenances.first.position }
          it { is_expected.to eql 0 }
        end

        context 'when a second maintainers is added' do
          subject(:position) { project.project_maintenances.last.position }

          let!(:existing) { create :project_maintenance }
          let!(:project) { existing.project }

          it { is_expected.to eql 1 }
        end
      end
    end
  end
end
