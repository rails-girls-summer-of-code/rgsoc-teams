require 'spec_helper'

RSpec.describe UsersHelper do

  describe "#show_availability" do
    let(:user) { create :user }

    context 'when the user is available' do
      before do
        user.update(availability: true)
      end

      it 'returns true' do
        expect(show_availability(user.availability)).to eql "I am available for this season!"
      end
    end

    context 'when the user is not available' do
      before do
        user.update(availability: false)
      end

      it 'returns false' do
        expect(show_availability(user.availability)).to eql "I am not available for this season."
      end
    end
  end
end