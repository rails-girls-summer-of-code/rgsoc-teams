require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe '#current_student' do
    subject(:current_student) { controller.current_student }

    context 'with a signed in user' do
      let(:user) { create(:user) }

      before { sign_in user }

      it 'returns a student for the user' do
        expect(current_student).to be_a(Student)
        expect(current_student).to have_attributes(id: user.id, name: user.name)
      end
    end

    context 'without a signed in user' do
      it { is_expected.to be_nil }
    end
  end
end
