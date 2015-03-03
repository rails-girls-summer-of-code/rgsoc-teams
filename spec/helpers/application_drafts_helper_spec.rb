require 'spec_helper'

RSpec.describe ApplicationDraftsHelper do

  describe '#may_edit?' do
    it 'returns false for nil' do
      expect(may_edit?(nil)).to be_falsey
    end

    it 'returns false if student is not persisted' do
      expect(may_edit?(Student.new)).to be_falsey
    end

    context 'as a stranger' do
      it 'returns false' do
        skip
      end
    end

    context 'as another student from the team' do
      skip
    end

    context 'as a non-student from the team' do
      skip
    end

    context 'as the student herself' do
      skip
    end
  end
end
