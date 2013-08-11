require 'spec_helper'

describe Activity do
  it { should belong_to(:team) }

  describe 'scopes' do
    describe '.with_kind' do
      pending 'TODO'
    end

    describe '.by_team' do
      pending 'TODO'
    end

    describe '.ordered' do
      pending 'TODO'
    end
  end
end
