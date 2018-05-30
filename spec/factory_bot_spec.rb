require 'rails_helper'

RSpec.describe FactoryBot do
  describe '#lint' do
    it 'does not raise any exception when creating models' do
      described_class.lint traits: true
    end
  end
end
