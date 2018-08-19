require 'rails_helper'

RSpec.describe Mentor::Student, type: :model do
  describe 'attributes' do
    subject { described_class.new }

    it { is_expected.to respond_to :coding_level             }
    it { is_expected.to respond_to :name                     }
    it { is_expected.to respond_to :code_samples             }
    it { is_expected.to respond_to :learning_history         }
    it { is_expected.to respond_to :language_learning_period }
    it { is_expected.to respond_to :skills                   }
  end
end
