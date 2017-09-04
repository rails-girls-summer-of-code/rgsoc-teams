require 'spec_helper'

describe User::AvailabilitySwitcher do
  describe '.reset' do
    let!(:coach_available) { create :coach, :available }
    let!(:user_available) { create :user, :available }
    before do 
      User::AvailabilitySwitcher.reset
    end

    context 'when an user is a coach' do
      it 'reset the availability to false' do
        expect(coach_available.reload.availability).to be false
      end
    end

    context 'when an user is not a coach' do
      it 'does not reset the availability to false' do
        expect(user_available.reload.availability).to be true
      end
    end
  end
end
