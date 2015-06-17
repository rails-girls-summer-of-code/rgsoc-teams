require 'spec_helper'

RSpec.describe StatusUpdate do

  context 'with associations' do
    it { is_expected.to belong_to :team }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of :team }
    it { is_expected.to validate_presence_of :subject }
    it { is_expected.to validate_presence_of :body }
  end
end
