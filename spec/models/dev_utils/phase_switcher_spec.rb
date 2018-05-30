require 'rails_helper'

RSpec.describe DevUtils::SeasonPhaseSwitcher, type: :model do
  context '.destined' do
    let(:season) { Season.current }

    context 'when the input is valid' do
      it 'gets called on the season object' do
        phase = :fake_application_phase
        described_class.destined(phase)
        season.reload
        expect(season).to be_application_period
      end

      it 'changes also when real time happens to be within application_period' do
        phase = :fake_proposals_phase
        described_class.destined(phase)
        season.reload
        expect(season).not_to be_application_period
      end
    end

    context 'when the input is malicious' do
      it 'does not change the season dates' do
        phase = :bad_intentions
        RSpec::Matchers.define_negated_matcher :not_change, :change
        expect {
          described_class.destined(phase)
        }.to raise_error(ArgumentError).and not_change { Season.current.reload }
      end
    end
  end
end
