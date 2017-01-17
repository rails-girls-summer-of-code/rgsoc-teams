require 'spec_helper'

describe Mentor::Student, :focus do
  describe 'attributes' do
    subject { described_class.new }

    it { is_expected.to respond_to :coding_level     }
    it { is_expected.to respond_to :code_samples     }
    it { is_expected.to respond_to :learning_history }
    it { is_expected.to respond_to :code_background  }
    it { is_expected.to respond_to :skills           }
  end
end
