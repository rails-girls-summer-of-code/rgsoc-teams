require 'spec_helper'

RSpec.describe Project do
  it { is_expected.to validate_presence_of(:name) }

  context 'with associations' do
    it { is_expected.to belong_to(:submitter).class_name(User) }
  end

  context 'as a finite state machine' do
    it 'starts as "proposed"' do
      expect(subject).to be_proposed
    end

    context 'with a proposed project' do
      subject { create :project }

      it 'can be accepted' do
        expect(subject).to be_may_accept
        expect { subject.accept! }.to \
          change { subject.accepted? }.to true
      end

      it 'can be rejected' do
        expect(subject).to be_may_reject
        expect { subject.reject! }.to \
          change { subject.rejected? }.to true
      end

    end

  end
end
