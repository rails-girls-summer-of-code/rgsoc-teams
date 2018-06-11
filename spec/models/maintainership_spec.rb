require 'rails_helper'

RSpec.describe Maintainership, type: :model do
  describe 'its associations' do
    it { is_expected.to belong_to :project }
    it { is_expected.to belong_to :user }
  end

  describe 'its validations' do
    it { is_expected.to validate_uniqueness_of(:project_id).scoped_to(:user_id) }
  end
end
