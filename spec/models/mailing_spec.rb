require 'spec_helper'

describe Mailing do
  it { should have_many(:submissions).dependent(:destroy) }

  describe '#sent?' do
    pending 'TODO'
  end

  describe '#submit' do
    pending 'TODO'
  end

  describe '#recipients' do
    pending 'TODO'
  end
end