require 'spec_helper'

RSpec.describe CreatesApplicationFromDraft do
  let(:application_draft) { build_stubbed :application_draft }

  subject { described_class.new application_draft }

  describe 'its constructor' do
    it 'sets the application draft' do
      subject = described_class.new application_draft
      expect(subject.application_draft).to eql application_draft
    end
  end

  describe '#save' do

    context 'with a draft that is not ready yet' do
      let(:application_draft) { ApplicationDraft.new }

      it 'will not create an application' do
        expect { subject.save }.not_to change { ApplicationDraft.count }
      end

      it 'returns nil' do
        expect(subject.save).to be_nil
      end
    end

    context 'carrying over the user attributes' do
      skip
    end

    it 'marks the draft as applied' do
      skip
    end

    it 'pings the mentors' do
      skip
    end

  end
end
