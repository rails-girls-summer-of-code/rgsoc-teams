require 'spec_helper'

describe Rating::Table do
  describe 'attributes' do
    let(:applications) { build_list(:application, 3) }

    subject { described_class.new(applications: applications) }

    it 'has applications' do
      expect(subject.applications).to eq applications
    end
  end

  describe 'filtering and sorting' do
    let(:blank)        { FactoryGirl.build(:application, id: 4) }
    let(:less_coaches) { FactoryGirl.build(:application, id: 1, flags: ['less_than_two_coaches']) }
    let(:remote)       { FactoryGirl.build(:application, id: 2, flags: ['remote_team']) }
    let(:male)         { FactoryGirl.build(:application, id: 3, flags: ['male_gender']) }
    let(:applications) { [blank, less_coaches, remote, male] }

    subject { described_class.new(applications: applications, options: options) }

    context 'with default sorting' do
      context 'with hide_flag options are set' do
        let(:options) { { hide_flags: %w(remote_team male_gender) } }

        it 'does not return flagged applications ordered by id' do
          expect(subject.applications).to eq [less_coaches, blank]
        end
      end

      context 'without hide_flags set' do
        let(:options) { {} }

        it 'returns all applications' do
          expect(subject.applications).to eq [less_coaches, remote, male, blank]
        end
      end
    end

    context 'sorting by average_points' do
      let(:options) { { hide_flags: %w(less_than_two_coaches), order: 'average_points' } }

      before do
        allow(male).to receive(:average_points) { 5.0 }
        allow(blank).to receive(:average_points) { 10.0 }
        allow(remote).to receive(:average_points) { 0.0 }
      end

      it 'returns filtered and sorted applications' do
        expect(subject.applications).to eq [blank, male, remote]
      end
    end
  end
end
