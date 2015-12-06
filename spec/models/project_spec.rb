require 'spec_helper'

RSpec.describe Project do

  it_behaves_like 'HasSeason'

  context 'with associations' do
    it { is_expected.to belong_to(:submitter).class_name(User) }
    it { is_expected.to have_many(:comments).dependent(:destroy) }
  end

  context 'with validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:submitter) }
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

  describe '#taglist' do
    it 'returns an empty string when tags are empty' do
      expect(subject.taglist).to eql ''
    end

    it 'returns a comma-separated string' do
      subject.tags = %w[rails ruby]
      expect(subject.taglist).to eql 'rails, ruby'
    end
  end

  describe '#taglist=' do
    it 'sets the tags by splitting at comma' do
      expect { subject.taglist = "foo, bar" }.
        to change { subject.tags }.to %w[foo bar]
    end

    it 'removes empty values' do
      expect { subject.taglist = "foo, , bar" }.
        to change { subject.tags }.to %w[foo bar]
    end
  end

end
